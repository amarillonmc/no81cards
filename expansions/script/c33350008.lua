--传说之魂的羁绊
if not pcall(function() require("expansions/script/c10199990") end) then require("script/c10199990") end
local m=33350008
local cm=_G["c"..m]
function c33350008.initial_effect(c)
    local e2=rsef.I(c,{m,0},nil,"sp","tg",LOCATION_GRAVE,nil,aux.bfgcost,rstg.target2(cm.fun,rsop.list(cm.xyzfilter,nil,LOCATION_MZONE)),cm.xyzop)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m)
	e1:SetCondition(cm.condition)
	e1:SetCost(cm.cost)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)

end
cm.setname="TaleSouls"
function cm.fun(g,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,0,tp,LOCATION_GRAVE)
end
function cm.xyzfilter(c,e,tp)
	return c.setname=="TaleSouls" and c:IsType(TYPE_XYZ) and c:GetOverlayCount()>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
end
function cm.xyzop(e,tp)
	rsof.SelectHint(tp,HINTMSG_SELF)
	local tc=Duel.SelectMatchingCard(tp,cm.xyzfilter,tp,LOCATION_MZONE,0,1,1,nil):GetFirst()
	if not tc then return end
	Duel.HintSelection(rsgf.Mix2(tc))
	if not tc:RemoveOverlayCard(tp,1,1,REASON_EFFECT) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
	local s=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,0)
	local nseq=math.log(s,2)
	Duel.MoveSequence(tc,nseq)
	local tc2=Duel.GetOperatedGroup():GetFirst()
	if tc2 and tc2:IsType(TYPE_MONSTER) and tc2:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
		rssf.SpecialSummon(tc2)
	end
end
function cm.cfilter3(c,tp)
	return cm.cfilter(c) and c:IsControler(tp)
end
function cm.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:GetCount()==1 and eg:IsExists(cm.cfilter3,1,nil,tp)
end
function cm.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToRemove() and eg:GetFirst():CheckRemoveOverlayCard(tp,1,REASON_EFFECT) end
	Duel.SetTargetCard(eg)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,c,1,tp,0)
end
function cm.rmop(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not c:IsRelateToEffect(e) or Duel.Remove(c,POS_FACEUP,REASON_EFFECT)<=0 or not tc:IsRelateToEffect(e) or not tc:CheckRemoveOverlayCard(tp,1,REASON_EFFECT) then return end
	tc:RemoveOverlayCard(tp,1,1,REASON_COST)
	local tc2=Duel.GetOperatedGroup():GetFirst()
	if tc2:IsType(TYPE_MONSTER) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and tc2:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
	   Duel.SpecialSummon(tc2,0,tp,tp,false,false,POS_FACEUP)
	end
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function cm.cfilter(c)
	return c:IsFaceup() and c.setname=="TaleSouls"
end
function cm.cfilter2(c)
	return c:IsCode(33350001) and c:IsAbleToGraveAsCost()
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.cfilter2,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,cm.cfilter2,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function cm.filter(c,e,tp)
	return c:IsCode(33350010) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
