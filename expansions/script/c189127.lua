--U-official
c189127.named_with_Arknight=1
function c189127.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(189127,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_SPSUM_PARAM+EFFECT_FLAG_UNCOPYABLE)
	e1:SetTargetRange(POS_FACEUP_DEFENSE,0)
	e1:SetRange(LOCATION_HAND)  
	e1:SetCountLimit(1,189127+EFFECT_COUNT_CODE_OATH+EFFECT_COUNT_CODE_DUEL)
	e1:SetCondition(c189127.hspcon) 
	e1:SetOperation(c189127.hspop)
	c:RegisterEffect(e1) 
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(189127,1))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_SPSUM_PARAM+EFFECT_FLAG_UNCOPYABLE)
	e1:SetTargetRange(POS_FACEUP_DEFENSE,1)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,189127+EFFECT_COUNT_CODE_OATH+EFFECT_COUNT_CODE_DUEL)
	e1:SetCondition(c189127.hspcon)  
	c:RegisterEffect(e1) 
	--disable 
	local e2=Effect.CreateEffect(c)  
	e2:SetCategory(CATEGORY_DISABLE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F) 
	e2:SetCode(EVENT_SUMMON_SUCCESS) 
	e2:SetProperty(EFFECT_FLAG_DELAY) 
	e2:SetTarget(c189127.distg) 
	e2:SetOperation(c189127.disop) 
	c:RegisterEffect(e2) 
	local e3=e2:Clone() 
	e3:SetCode(EVENT_SPSUMMON_SUCCESS) 
	c:RegisterEffect(e3) 
end
function c189127.hspcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end 
function c189127.hspop(e,tp,eg,ep,ev,re,r,rp,c)
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS) 
	e1:SetCode(EVENT_PHASE+PHASE_END) 
	e1:SetCountLimit(1)  
	e1:SetCondition(c189127.hdrcon) 
	e1:SetOperation(c189127.hdrop)  
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end 
function c189127.hdrcon(e,tp,eg,ep,ev,re,r,rp)
	return true 
end 
function c189127.hdrop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,189127)
	Duel.Draw(tp,1,REASON_EFFECT) 
end 
function c189127.xdisfil(c,sc) 
	local xseq=sc:GetSequence() 
	local seq=c:GetSequence() 
	return seq<5 and math.abs(seq-xseq)==1 
end 
function c189127.distg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return true end  
	local c=e:GetHandler() 
	local g1=c:GetColumnGroup():Filter(Card.IsControler,nil,tp) 
	local g2=Duel.GetMatchingGroup(c189127.xdisfil,tp,LOCATION_MZONE,0,nil,c) 
	g1:Merge(g2) 
	local g=g1:Filter(aux.NegateAnyFilter,nil) 
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,g:GetCount(),0,0) 
end 
function c189127.disop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler() 
	local g1=c:GetColumnGroup():Filter(Card.IsControler,nil,tp) 
	local g2=Duel.GetMatchingGroup(c189127.xdisfil,tp,LOCATION_MZONE,0,nil,c) 
	g1:Merge(g2) 
	local g=g1:Filter(aux.NegateAnyFilter,nil)  
	if g:GetCount()>0 then 
		local tc=g:GetFirst() 
		while tc do  
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_DISABLE) 
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)  
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		tc:RegisterEffect(e2)
		if tc:IsType(TYPE_TRAPMONSTER) then
			local e3=e1:Clone()
			e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
			tc:RegisterEffect(e3)
		end
		tc=g:GetNext() 
		end  
	end 
end 









