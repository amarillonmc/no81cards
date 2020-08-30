local m=82208130
local cm=_G["c"..m]
cm.name="龙法师 魔导圣峰"
function cm.initial_effect(c)
	--Activate  
	local e1=Effect.CreateEffect(c)  
	e1:SetType(EFFECT_TYPE_ACTIVATE)  
	e1:SetCode(EVENT_FREE_CHAIN)  
	c:RegisterEffect(e1)  
	--atk&def  
	local e2=Effect.CreateEffect(c)  
	e2:SetType(EFFECT_TYPE_FIELD)  
	e2:SetCode(EFFECT_UPDATE_ATTACK)  
	e2:SetRange(LOCATION_FZONE)  
	e2:SetTargetRange(LOCATION_MZONE,0)  
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x6299))  
	e2:SetValue(700)  
	c:RegisterEffect(e2)  
	local e3=e2:Clone()  
	e3:SetCode(EFFECT_UPDATE_DEFENSE)  
	c:RegisterEffect(e3)
	--spsummon  
	local e4=Effect.CreateEffect(c)  
	e4:SetDescription(aux.Stringid(m,0))
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)  
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)  
	e4:SetType(EFFECT_TYPE_IGNITION)  
	e4:SetRange(LOCATION_FZONE)
	e4:SetCountLimit(1,m)  
	e4:SetCost(cm.spcost)  
	e4:SetTarget(cm.sptg)  
	e4:SetOperation(cm.spop)  
	c:RegisterEffect(e4)  
end
function cm.spcost(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.GetCurrentPhase()~=PHASE_MAIN2 end  
	local e1=Effect.CreateEffect(e:GetHandler())  
	e1:SetType(EFFECT_TYPE_FIELD)  
	e1:SetCode(EFFECT_CANNOT_BP)  
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)  
	e1:SetTargetRange(1,0)  
	e1:SetReset(RESET_PHASE+PHASE_END)  
	Duel.RegisterEffect(e1,tp)  
end  
function cm.filter(c,e,tp)  
	return c:IsSetCard(0x6299) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)  
end  
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)  
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and chkc:IsCanBeSpecialSummoned(e,0,tp,false,false) end  
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0  
		and Duel.IsExistingTarget(cm.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end  
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)  
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)  
	local g=Duel.SelectTarget(tp,cm.filter,tp,LOCATION_GRAVE,0,1,ft,nil,e,tp)  
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,g:GetCount(),0,0)  
end  
function cm.spop(e,tp,eg,ep,ev,re,r,rp)  
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)  
	if ft<=0 then return end  
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)  
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)  
	if sg:GetCount()>1 and Duel.IsPlayerAffectedByEffect(tp,59822133) then return end  
	if sg:GetCount()>ft then  
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)  
		sg=sg:Select(tp,ft,ft,nil)  
	end  
	local ct=Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)  
	Duel.SetLP(tp,Duel.GetLP(tp)-ct*700)  
end  
