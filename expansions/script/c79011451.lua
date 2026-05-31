--轮回六道 通灵术·阎王
function c79011451.initial_effect(c)
	aux.AddCodeList(c,79011444)
	--Activate 
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(79011451,1)) 
	e1:SetType(EFFECT_TYPE_ACTIVATE) 
	e1:SetCode(EVENT_FREE_CHAIN)  
	e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)   
	return Duel.IsExistingMatchingCard(function(c) return c:IsFaceup() and c:IsCode(79011444) end,tp,LOCATION_MZONE,0,1,nil) end)
	e1:SetTarget(c79011451.actg) 
	c:RegisterEffect(e1) 
	--xx 
	local e2=Effect.CreateEffect(c)  
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_ADJUST)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(c79011451.thcon) 
	e2:SetOperation(c79011451.thop)
	e2:SetLabelObject(e1)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)  
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_PHASE+PHASE_END) 
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c79011451.tgcon) 
	e3:SetOperation(c79011451.tgop) 
	c:RegisterEffect(e3)
	--remain field
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetCode(EFFECT_REMAIN_FIELD)
	c:RegisterEffect(e3)
end
c79011451.SetCard_Pain_PBLK_Skill=true 
function c79011451.actg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=Duel.GetLocationCount(1-tp,LOCATION_MZONE,PLAYER_NONE,0) 
	if chk==0 then return ft>0 end
	local seq=Duel.SelectDisableField(tp,1,0,LOCATION_MZONE,0)
	e:SetLabel(seq)
	Duel.Hint(HINT_ZONE,tp,seq)
end
function c79011451.cfilter(c,seq,tp)
	local nseq=c:GetSequence()
	if c:IsLocation(LOCATION_MZONE) then
		if c:IsControler(1-tp) then nseq=nseq+16 end
		return c:IsFaceup() and c:IsType(TYPE_EFFECT) and bit.extract(seq,nseq)~=0
	else
		nseq=c:GetPreviousSequence()
		if c:IsPreviousControler(1-tp) then nseq=nseq+16 end
		return bit.band(c:GetPreviousTypeOnField(),TYPE_EFFECT)~=0 and bit.extract(seq,nseq)~=0
	end
end
function c79011451.thcon(e,tp,eg,ep,ev,re,r,rp)
	local seq=e:GetLabelObject():GetLabel() 
	local g=Duel.GetMatchingGroup(c79011451.cfilter,tp,0,LOCATION_MZONE,nil,seq,tp)
	return g:GetCount()>0
end 
function c79011451.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c79011451.thcon(e,tp,eg,ep,ev,re,r,rp) then  
		Duel.Hint(HINT_CARD,0,79011451)
		local seq=e:GetLabelObject():GetLabel() 
		local g=Duel.GetMatchingGroup(c79011451.cfilter,tp,0,LOCATION_MZONE,nil,seq,tp) 
		Duel.SendtoGrave(c,REASON_EFFECT) 
		Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)
	end 
end
function c79011451.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==1-tp 
end 
function c79011451.tgop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()
	Duel.Hint(HINT_CARD,0,79011451)	  
	Duel.SendtoGrave(c,REASON_EFFECT)
end 


