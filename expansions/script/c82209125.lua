--2+2=5
local m=82209125
local cm=_G["c"..m]
function cm.initial_effect(c)  
	--Activate  
	local e1=Effect.CreateEffect(c)  
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)  
	e1:SetType(EFFECT_TYPE_ACTIVATE)  
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)  
	e1:SetCode(EVENT_FREE_CHAIN)  
	e1:SetTarget(cm.target)  
	e1:SetOperation(cm.activate)  
	c:RegisterEffect(e1)  
end  
function cm.spfilter1(c,e,tp)  
	return c:IsType(TYPE_TUNER) and c:IsLevelAbove(1) and c:IsFaceup() and c:IsCanBeEffectTarget(e)
		and Duel.IsExistingMatchingCard(cm.spfilter2,tp,LOCATION_MZONE,0,1,nil,e,tp,c)  
end  
function cm.spfilter2(c,e,tp,mc)  
	if c:IsType(TYPE_TUNER) or not (c:IsFaceup() and c:IsCanBeEffectTarget(e)) then return false end  
	local e1=Effect.CreateEffect(e:GetHandler())  
	e1:SetType(EFFECT_TYPE_SINGLE)  
	e1:SetCode(EFFECT_UPDATE_LEVEL)  
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)  
	e1:SetValue(1)  
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)  
	mc:RegisterEffect(e1) 
	local res=Duel.IsExistingMatchingCard(Card.IsSynchroSummonable,tp,LOCATION_EXTRA,0,1,nil,nil,Group.FromCards(c,mc))  
	if e1 then e1:Reset() end 
	return res  
end  
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)  
	if chkc then return false end  
	if chk==0 then return Duel.GetLocationCountFromEx(tp)>0  
		and Duel.IsExistingMatchingCard(cm.spfilter1,tp,LOCATION_MZONE,0,1,nil,e,tp) end 
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)  
	local g1=Duel.SelectMatchingCard(tp,cm.spfilter1,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)  
	local g2=Duel.SelectMatchingCard(tp,cm.spfilter2,tp,LOCATION_MZONE,0,1,1,nil,e,tp,g1:GetFirst())
	e:SetLabelObject(g1:GetFirst())
	g1:Merge(g2)
	Duel.SetTargetCard(g1)  
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end  
function cm.spfilter3(c,e)
	return c:IsRelateToEffect(e) and c:IsFaceup()
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)  
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(cm.spfilter3,nil,e)  
	if g:FilterCount(Card.IsType,nil,TYPE_TUNER)~=1 then return end  
	local tuner=e:GetLabelObject()
	if (not g:IsContains(tuner) and tuner:IsType(TYPE_TUNER)) then return end
	local e1=Effect.CreateEffect(e:GetHandler())  
	e1:SetType(EFFECT_TYPE_SINGLE)  
	e1:SetCode(EFFECT_UPDATE_LEVEL)  
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)  
	e1:SetValue(1)  
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)  
	tuner:RegisterEffect(e1) 
	if g:GetCount()~=2 then return end
	local sg=Duel.GetMatchingGroup(Card.IsSynchroSummonable,tp,LOCATION_EXTRA,0,nil,nil,g)  
	if sg:GetCount()>0 and Duel.GetLocationCountFromEx(tp)>0 then  
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)  
		local sc=sg:Select(tp,1,1,nil):GetFirst()  
		Duel.SynchroSummon(tp,sc,nil,g)  
	end  
end  