local m=82228633
local cm=_G["c"..m]
cm.name="孑影之骁骑"
function cm.initial_effect(c)
	--link summon  
	c:EnableReviveLimit()  
	aux.AddLinkProcedure(c,cm.matfilter,2,99)
	--special summon  
	local e1=Effect.CreateEffect(c)  
	e1:SetDescription(aux.Stringid(m,0))  
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)  
	e1:SetType(EFFECT_TYPE_IGNITION)  
	e1:SetRange(LOCATION_MZONE)  
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)  
	e1:SetCountLimit(1,m)  
	e1:SetTarget(cm.sptg1)  
	e1:SetOperation(cm.spop1)  
	c:RegisterEffect(e1)  
	--pos  
	local e2=Effect.CreateEffect(c)  
	e2:SetType(EFFECT_TYPE_FIELD)  
	e2:SetCode(EFFECT_SET_POSITION)  
	e2:SetRange(LOCATION_MZONE)  
	e2:SetTargetRange(0,LOCATION_MZONE)  
	e2:SetTarget(cm.postg)  
	e2:SetValue(POS_FACEUP_DEFENSE)  
	c:RegisterEffect(e2)  
	--pierce  
	local e4=Effect.CreateEffect(c)  
	e4:SetType(EFFECT_TYPE_SINGLE)  
	e4:SetCode(EFFECT_PIERCE)  
	c:RegisterEffect(e4) 
	local e5=Effect.CreateEffect(c)  
	e5:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e5:SetType(EFFECT_TYPE_FIELD)  
	e5:SetCode(EFFECT_CHANGE_DAMAGE)  
	e5:SetRange(LOCATION_MZONE)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)  
	e5:SetTargetRange(1,1)  
	e5:SetValue(cm.damval)  
	c:RegisterEffect(e5)  
end
function cm.matfilter(c)
	return c:IsLinkSetCard(0x3299)
end  
function cm.spfilter1(c,e,tp)  
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE,1-tp)  
end  
function cm.sptg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)  
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(1-tp) and cm.spfilter1(chkc,e,tp) end  
	if chk==0 then return Duel.GetLocationCount(1-tp,LOCATION_MZONE,tp)>0  
		and Duel.IsExistingTarget(cm.spfilter1,tp,0,LOCATION_GRAVE,1,nil,e,tp) end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)  
	local g=Duel.SelectTarget(tp,cm.spfilter1,tp,0,LOCATION_GRAVE,1,1,nil,e,tp)  
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)  
end  
function cm.spop1(e,tp,eg,ep,ev,re,r,rp)  
	local tc=Duel.GetFirstTarget()  
	if tc:IsRelateToEffect(e) then  
		Duel.SpecialSummon(tc,0,tp,1-tp,false,false,POS_FACEUP_DEFENSE)  
	end  
end  
function cm.postg(e,c)  
	return c:IsFaceup()  
end  
function cm.damval(e,re,dam,r,rp,rc)  
	if bit.band(r,REASON_BATTLE)~=0 and Duel.GetAttacker()==e:GetHandler() and e:GetHandler():GetBattleTarget()~=nil and e:GetHandler():GetBattleTarget():IsPosition(POS_DEFENSE) then  
		return dam*3
	else return dam end  
end 