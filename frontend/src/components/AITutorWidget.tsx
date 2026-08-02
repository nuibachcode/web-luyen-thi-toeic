import { useState, useRef, useEffect } from 'react';

type Message = {
  sender: 'user' | 'ai';
  text: string;
};

const DEFAULT_WELCOME: Message = {
  sender: 'ai',
  text: 'Xin chào! Tôi là **AeroAI Tutor** 🤖 trợ lý trợ giảng TOEIC 24/7 của bạn. Bạn đang cần giải đáp về từ vựng, ngữ pháp hay mẹo thi Part nào không?'
};

export default function AITutorWidget() {
  const [isOpen, setIsOpen] = useState(false);
  const [messages, setMessages] = useState<Message[]>(() => {
    try {
      const saved = localStorage.getItem('toeic_chat_history');
      if (saved) return JSON.parse(saved);
    } catch (e) {
      console.warn('Failed to parse chat history:', e);
    }
    return [DEFAULT_WELCOME];
  });

  const [input, setInput] = useState('');
  const [loading, setLoading] = useState(false);
  const messagesEndRef = useRef<HTMLDivElement>(null);

  useEffect(() => {
    try {
      localStorage.setItem('toeic_chat_history', JSON.stringify(messages));
    } catch (e) {
      console.warn('Failed to save chat history:', e);
    }
  }, [messages]);

  const scrollToBottom = () => {
    messagesEndRef.current?.scrollIntoView({ behavior: 'smooth' });
  };

  useEffect(() => {
    if (isOpen) scrollToBottom();
  }, [messages, isOpen]);

  const handleClearHistory = () => {
    if (window.confirm('Bạn có chắc chắn muốn xóa toàn bộ lịch sử trò chuyện này?')) {
      setMessages([DEFAULT_WELCOME]);
      localStorage.removeItem('toeic_chat_history');
    }
  };

  const handleSend = async (customMessage?: string) => {
    const textToSend = customMessage || input.trim();
    if (!textToSend || loading) return;

    const newMessages: Message[] = [...messages, { sender: 'user', text: textToSend }];
    setMessages(newMessages);
    if (!customMessage) setInput('');
    setLoading(true);

    try {
      const gateway = import.meta.env.VITE_API_GATEWAY_URL || 'http://localhost:4000';
      const token = localStorage.getItem('toeic_jwt');
      const targetScore = Number(localStorage.getItem('toeic_target_score')) || 750;

      const res = await fetch(`${gateway}/api/ai/chat`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          ...(token ? { Authorization: `Bearer ${token}` } : {})
        },
        body: JSON.stringify({
          message: textToSend,
          history: newMessages.slice(-6),
          context: {
            page: window.location.pathname,
            targetScore,
            currentScore: 450
          }
        })
      });

      if (res.ok) {
        const data = await res.json();
        setMessages([...newMessages, { sender: 'ai', text: data.reply || 'Cảm ơn bạn đã đặt câu hỏi! Hãy tiếp tục luyện tập nhé.' }]);
      } else {
        setMessages([...newMessages, { sender: 'ai', text: '🤖 Rất tiếc, AI tạm thời đang bận. Bạn hãy thử lại sau giây lát nhé!' }]);
      }
    } catch (err) {
      setMessages([...newMessages, { sender: 'ai', text: '🤖 AeroAI đang sẵn sàng hỗ trợ bạn. Bạn có thể hỏi bất kỳ thắc mắc từ vựng hoặc ngữ pháp nào nhé!' }]);
    } finally {
      setLoading(false);
    }
  };

  return (
    <div style={{ position: 'fixed', bottom: '16px', right: '16px', zIndex: 9999, fontFamily: 'sans-serif' }}>
      {/* Chat Window Popup */}
      {isOpen && (
        <div 
          className="animate-fade-in"
          style={{
            width: 'min(380px, calc(100vw - 32px))',
            height: '540px',
            maxHeight: 'calc(100vh - 90px)',
            background: '#ffffff',
            borderRadius: '18px',
            boxShadow: '0 12px 36px rgba(0,0,0,0.18)',
            border: '1px solid #cbd5e1',
            display: 'flex',
            flexDirection: 'column',
            overflow: 'hidden',
            marginBottom: '12px'
          }}
        >
          {/* Header */}
          <div style={{
            background: 'linear-gradient(135deg, #1e40af, #2563eb)',
            color: '#ffffff',
            padding: '14px 18px',
            display: 'flex',
            alignItems: 'center',
            justifyContent: 'space-between'
          }}>
            <div style={{ display: 'flex', alignItems: 'center', gap: '10px' }}>
              <div style={{
                width: '36px', height: '36px', borderRadius: '50%', background: '#ffffff', color: '#2563eb',
                display: 'grid', placeItems: 'center', fontWeight: 800, fontSize: '18px'
              }}>
                🤖
              </div>
              <div>
                <h4 style={{ margin: 0, fontSize: '15px', fontWeight: 700 }}>AeroAI Tutor 990+</h4>
                <span style={{ fontSize: '11px', opacity: 0.9 }}>🟢 Trợ giảng TOEIC 24/7 </span>
              </div>
            </div>
            <div style={{ display: 'flex', alignItems: 'center', gap: '8px' }}>
              <button
                onClick={handleClearHistory}
                title="Xóa lịch sử trò chuyện"
                style={{ background: 'none', border: 'none', color: '#ffffff', fontSize: '15px', cursor: 'pointer', opacity: 0.8 }}
              >
                🗑️
              </button>
              <button
                onClick={() => setIsOpen(false)}
                style={{ background: 'none', border: 'none', color: '#ffffff', fontSize: '18px', cursor: 'pointer', opacity: 0.8 }}
              >
                ✕
              </button>
            </div>
          </div>

          {/* Quick Prompts */}
          <div style={{ background: '#f8fafc', padding: '8px 12px', borderBottom: '1px solid #e2e8f0', display: 'flex', gap: '6px', overflowX: 'auto' }}>
            {['Mẹo Part 5', 'Từ vựng hot', 'Kinh nghiệm Part 7', 'Động viên tôi'].map(prompt => (
              <button
                key={prompt}
                onClick={() => handleSend(prompt)}
                style={{
                  background: '#ffffff', border: '1px solid #cbd5e1', borderRadius: '14px',
                  padding: '4px 10px', fontSize: '11px', fontWeight: 600, color: '#2563eb', cursor: 'pointer', whiteSpace: 'nowrap'
                }}
              >
                💡 {prompt}
              </button>
            ))}
          </div>

          {/* Message List */}
          <div style={{ flex: 1, padding: '14px', overflowY: 'auto', display: 'flex', flexDirection: 'column', gap: '12px', background: '#f1f5f9' }}>
            {messages.map((m, idx) => (
              <div
                key={idx}
                style={{
                  alignSelf: m.sender === 'user' ? 'flex-end' : 'flex-start',
                  maxWidth: '85%',
                  background: m.sender === 'user' ? '#2563eb' : '#ffffff',
                  color: m.sender === 'user' ? '#ffffff' : '#1e293b',
                  padding: '10px 14px',
                  borderRadius: m.sender === 'user' ? '14px 14px 2px 14px' : '14px 14px 14px 2px',
                  boxShadow: '0 2px 6px rgba(0,0,0,0.05)',
                  fontSize: '13.5px',
                  lineHeight: '1.45',
                  whiteSpace: 'pre-wrap'
                }}
              >
                {m.text}
              </div>
            ))}
            {loading && (
              <div style={{ alignSelf: 'flex-start', background: '#ffffff', color: '#64748b', padding: '8px 12px', borderRadius: '12px', fontSize: '12px', fontStyle: 'italic' }}>
                ⏳ AeroAI đang suy nghĩ câu trả lời...
              </div>
            )}
            <div ref={messagesEndRef} />
          </div>

          {/* Input Area */}
          <form
            onSubmit={e => { e.preventDefault(); handleSend(); }}
            style={{ padding: '10px 12px', background: '#ffffff', borderTop: '1px solid #e2e8f0', display: 'flex', gap: '8px' }}
          >
            <input
              type="text"
              value={input}
              onChange={e => setInput(e.target.value)}
              placeholder="Hỏi AeroAI về từ vựng, ngữ pháp..."
              style={{ flex: 1, border: '1px solid #cbd5e1', borderRadius: '8px', padding: '8px 12px', fontSize: '13px', outline: 'none' }}
            />
            <button
              type="submit"
              disabled={loading || !input.trim()}
              style={{
                background: '#2563eb', color: '#ffffff', border: 'none', borderRadius: '8px',
                padding: '8px 14px', fontWeight: 700, fontSize: '13px', cursor: 'pointer', opacity: loading || !input.trim() ? 0.6 : 1
              }}
            >
              Gửi
            </button>
          </form>
        </div>
      )}

      {/* Floating Toggle Button */}
      <button
        onClick={() => setIsOpen(!isOpen)}
        style={{
          width: '56px',
          height: '56px',
          borderRadius: '50%',
          background: 'linear-gradient(135deg, #1d4ed8, #2563eb)',
          color: '#ffffff',
          border: 'none',
          boxShadow: '0 6px 20px rgba(37, 99, 235, 0.4)',
          cursor: 'pointer',
          display: 'grid',
          placeItems: 'center',
          fontSize: '26px',
          transition: 'transform 0.2s',
          float: 'right'
        }}
        onMouseEnter={e => e.currentTarget.style.transform = 'scale(1.08)'}
        onMouseLeave={e => e.currentTarget.style.transform = 'scale(1)'}
        title="Trợ lý Trợ giảng AeroAI"
      >
        {isOpen ? '✕' : '🤖'}
      </button>
    </div>
  );
}
