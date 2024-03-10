--S.B.系统终端 双倍解脱
local s,id,o=GetID()
function s.initial_effect(c)
	c:SetSPSummonOnce(id)
	--xyz summon
	aux.AddXyzProcedure(c,nil,2,2,s.ovfilter,aux.Stringid(id,0),99,nil)
	c:EnableReviveLimit()
	
	--atk/def
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	--e2:SetCondition(s.adcon)
	e2:SetValue(s.adval)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e3)
	
	--remove
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,1))
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_RANGE+EFFECT_FLAG_IGNORE_IMMUNE)
	e4:SetCode(EFFECT_TO_GRAVE_REDIRECT)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(s.rmcondition)
	e4:SetTarget(s.rmtarget)
	e4:SetTargetRange(0xff,0xff)
	e4:SetValue(LOCATION_REMOVED)
	c:RegisterEffect(e4)

	--draw
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(id,2))
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e5:SetCategory(CATEGORY_DRAW)
	e5:SetCode(EVENT_PHASE+PHASE_END)
	e5:SetRange(LOCATION_MZONE)
	e5:SetTarget(s.dwtg)
	e5:SetOperation(s.dwop)
	c:RegisterEffect(e5)
end

function s.ovfilter(c)
	return c:IsFaceup() and c:IsCode(21401127)
end

function s.adval(e,c)
	return e:GetHandler():GetOverlayCount()*400
end

function s.rmcondition(e)
	return e:GetHandler():GetOverlayGroup():IsExists(Card.IsSetCard,1,nil,0x3d70)
end

function s.rmtarget(e,c)
	return not c:IsLocation(0x80) and not c:IsType(TYPE_SPELL+TYPE_TRAP)
end

function s.dwtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function s.dwop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or not c:CheckRemoveOverlayCard(tp,1,REASON_EFFECT) then return end
	local g=c:GetOverlayGroup()
	local ng=g:Filter(Card.IsSetCard,nil,0x3d70)
	if #ng>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVEXYZ)
		local sc = ng:Select(tp,1,1,nil):GetFirst()
		if Duel.SendtoGrave(sc,REASON_EFFECT)>0 then
			Duel.RaiseSingleEvent(sc,EVENT_DETACH_MATERIAL,e,0,0,0,0)
			Duel.Draw(tp,1,REASON_EFFECT)
		end
	end
end

