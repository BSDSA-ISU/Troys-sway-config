from PySide6.QtWidgets import (QApplication, QWidget, QVBoxLayout, 
                             QTextBrowser, QTextEdit, QPushButton, QHBoxLayout)  # Changed QLineEdit to QTextEdit
from PySide6.QtCore import QThread, Signal, Slot, QEvent, Qt  # Added QEvent and Qt
from PySide6.QtGui import QFont, QKeyEvent, QDesktopServices
import sys
from google import genai

import os, dotenv

# --- FIX: Tell python-dotenv to look inside PyInstaller's temporary runtime path ---
if getattr(sys, 'frozen', False):
    # Running inside the packed executable
    bundle_dir = sys._MEIPASS
else:
    # Running normally as a script
    bundle_dir = os.path.dirname(os.path.abspath(__file__))

dotenv_path = os.path.join(bundle_dir, '.env')
dotenv.load_dotenv(dotenv_path)
# ----------------------------------------------------------------------------------

# Now it safely pulls the key out of the embedded runtime environment
api_key = os.getenv("GEMINI_API_KEY")

dotenv.load_dotenv()

os.getenv("KEY", None)

# A worker thread handles the API stream so the GUI doesn't freeze up
class StreamWorker(QThread):
    chunk_received = Signal(str)
    finished = Signal()

    def __init__(self, chat_session, prompt):
        super().__init__()
        self.chat_session = chat_session
        self.prompt = prompt

    def run(self):
        try:
            # Use the streaming variant of the chat session
            response_stream = self.chat_session.send_message_stream(self.prompt)
            for chunk in response_stream:
                if chunk.text:
                    self.chunk_received.emit(chunk.text)
        except Exception as e:
            self.chunk_received.emit(f"\n*Error:* {str(e)}")
        self.finished.emit()


class GeminiChatGUI(QWidget):
    def __init__(self):
        super().__init__()
        self.client = genai.Client()
        
        # Define your custom system instructions
        linux_instructions = """You are a useful assistant named 'Gemini-Chan'. Stay in the Linux world only for your answers. Do not mention or provide instructions for Windows.
        if user still insist for WIndows questions just dump a reason why use linux lmao"""
        
        # Create the chat and pass the instruction via the config argument
        self.chat = self.client.chats.create(
            model='gemini-3.1-flash-lite',
            config={'system_instruction': linux_instructions}
        )
        
        self.chat_history_markdown = "### Assistant\n*chat engine ready.*\n\n"
        self.init_ui()
        
    def init_ui(self):
        self.setWindowTitle("Sway Assistant")
        self.resize(600, 700)
        
        main_layout = QVBoxLayout()
        input_layout = QHBoxLayout()
        
        self.chat_display = QTextBrowser()
        self.chat_display = QTextBrowser()
        # --- ADD THESE TWO LINES ---
        self.chat_display.setOpenLinks(False)  # Intercept the click event
        self.chat_display.anchorClicked.connect(lambda url: QtGui.QDesktopServices.openUrl(url)) # Open in browser
        self.chat_display.setFont(QFont("Monospace", 10))
        
        # Apply CSS style for Markdown code blocks
        doc = self.chat_display.document()
        doc.setDefaultStyleSheet("""
            pre { background-color: #2d2d2d; color: #f8f8f2; font-family: 'Monospace'; padding: 10px; border-radius: 4px; }
            code { background-color: #2d2d2d; color: #f8f8f2; font-family: 'Monospace'; }
        """)
        self.chat_display.setMarkdown(self.chat_history_markdown)
        
        # --- CHANGE 1: Swap QLineEdit for QTextEdit ---
        self.input_field = QTextEdit()
        self.input_field.setPlaceholderText("Type a message... (Shift+Enter for new line)")
        self.input_field.setMaximumHeight(80)  # Restrict height so it doesn't take over the screen
        self.input_field.setFont(QFont("Monospace", 10))
        
        # --- CHANGE 2: Install Event Filter to capture key combinations ---
        self.input_field.installEventFilter(self)
        
        self.send_btn = QPushButton("Send")
        self.send_btn.clicked.connect(self.send_message)
        
        input_layout.addWidget(self.input_field)
        input_layout.addWidget(self.send_btn)
        
        main_layout.addWidget(self.chat_display)
        main_layout.addLayout(input_layout)
        self.setLayout(main_layout)

    # --- CHANGE 3: Intercept Keypresses ---
    def eventFilter(self, obj, event):
        # Check if the event is a keypress happening inside the input_field
        if obj is self.input_field and event.type() == QEvent.KeyPress:
            if event.key() in (Qt.Key_Return, Qt.Key_Enter):
                # Case A: Shift + Enter -> Let Qt handle it normally (inserts a newline)
                if event.modifiers() & Qt.ShiftModifier:
                    return False
                
                # Case B: Enter alone -> Send the message
                else:
                    self.send_message()
                    return True  # Tell Qt we swallowed the event; don't add an accidental newline after sending
                    
        return super().eventFilter(obj, event)

    def send_message(self):
        # --- CHANGE 4: Use .toPlainText() instead of .text() ---
        user_text = self.input_field.toPlainText().strip()
        if not user_text:
            return
            
        self.chat_history_markdown += f"\n\n---\n\n**You:** {user_text}\n\n---\n\n**Gemini:** "
        self.chat_display.setMarkdown(self.chat_history_markdown)
        self.input_field.clear()
        
        self.input_field.setEnabled(False)
        self.send_btn.setEnabled(False)
        
        self.worker = StreamWorker(self.chat, user_text)
        self.worker.chunk_received.connect(self.append_stream_chunk)
        self.worker.finished.connect(self.stream_finished)
        self.worker.start()

    @Slot(str)
    def append_stream_chunk(self, text):
        self.chat_history_markdown += text
        self.chat_display.setMarkdown(self.chat_history_markdown)
        self.chat_display.verticalScrollBar().setValue(
            self.chat_display.verticalScrollBar().maximum()
        )

    @Slot()
    def stream_finished(self):
        self.input_field.setEnabled(True)
        self.send_btn.setEnabled(True)
        self.input_field.setFocus()


if __name__ == "__main__":
    app = QApplication(sys.argv)
    gui = GeminiChatGUI()
    gui.show()
    sys.exit(app.exec())