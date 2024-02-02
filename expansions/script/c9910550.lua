if QutryTxjp then return end
QutryTxjp = {}

function QutryTxjp.AddSpProcedure(c,m)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(QutryTxjp.SpCondition())
	e1:SetOperation(QutryTxjp.SpOperation())
	c:RegisterEffect(e1)
end
function QutryTxjp.SpCondition()
	return  function(e,c)
				if c==nil then return true end
				local tp=c:GetControler()
				return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
					and Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,nil)
			end
end
function QutryTxjp.SpOperation()
	return  function(e,tp,eg,ep,ev,re,r,rp,c)
				Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(9910550,0))
				local g=Duel.SelectMatchingCard(tp,Card.IsAbleToGrave,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,1,nil)
				Duel.SendtoGrave(g,REASON_COST+REASON_RETURN)
			end
end
function QutryTxjp.AddTgFlag(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_MOVE)
	e1:SetCondition(QutryTxjp.TgCondition())
	e1:SetOperation(QutryTxjp.TgOperation())
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_PHASE_START+PHASE_DRAW)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetOperation(QutryTxjp.TgOperation2())
	c:RegisterEffect(e2)
end
function QutryTxjp.TgCondition()
	return  function(e,tp,eg,ep,ev,re,r,rp)
				return e:GetHandler():IsLocation(LOCATION_GRAVE)
			end
end
function QutryTxjp.TgOperation()
	return  function(e,tp,eg,ep,ev,re,r,rp)
				local c=e:GetHandler()
				if c:IsPreviousLocation(LOCATION_REMOVED) and c:IsReason(REASON_RETURN) then
					c:RegisterFlagEffect(9910550,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(9910550,1))
				else
					c:RegisterFlagEffect(9910565,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(9910550,2))
				end
			end
end
function QutryTxjp.TgOperation2()
	return  function(e,tp,eg,ep,ev,re,r,rp)
				local c=e:GetHandler()
				local id=Duel.GetTurnCount()
				if c:GetTurnID()<id and not c:IsReason(REASON_RETURN) and c:GetFlagEffect(9910567)==0 then
					c:RegisterFlagEffect(9910566,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(9910550,3))
				end
			end
end
