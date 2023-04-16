--《女皇》·安宁的女王
local m=60001241
local cm=_G["c"..m]
function cm.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(cm.spcon)
	e1:SetOperation(cm.spop)
	c:RegisterEffect(e1)
end
function cm.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_HAND,0,1,c)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_HAND,0,1,5,c)
	Duel.SendtoGrave(g,REASON_COST+REASON_DISCARD)
	if g:GetCount()>=2 then
		local token=Duel.CreateToken(tp,3285552)
		Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
		local token=Duel.CreateToken(tp,3285552)
		Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
	end
	if g:GetCount()>=4 then
		local token=Duel.CreateToken(tp,3285552)
		Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
		local token=Duel.CreateToken(tp,3285552)
		Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
	end
end
	