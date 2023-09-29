local m=53707003
local cm=_G["c"..m]
cm.name="清响 念星觉"
cm.main_peacecho=true
if not require and dofile then function require(str) return dofile(str..".lua") end end
if not pcall(function() require("expansions/script/c53702500") end) then require("script/c53702500") end
function cm.initial_effect(c)
	SNNM.Peacecho(c,TYPE_MONSTER)
	SNNM.AllGlobalCheck(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(cm.spcon)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,m)
	e2:SetCost(cm.cost)
	e2:SetTarget(cm.target)
	e2:SetOperation(cm.operation)
	c:RegisterEffect(e2)
end
function cm.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetDecktopGroup(c:GetControler(),1)
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and g:GetFirst():IsFaceup()
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	if chk==0 then return true end
end
--妈 的 ，脑 抽 忘 了 嵌 套 过 滤 器 了
function cm.rmfilter(c)
	return c:IsRace(RACE_PLANT) and c:IsAbleToRemoveAsCost(POS_FACEDOWN)
end
function cm.spfilter1(c,e,tp)
	return c:IsRace(RACE_PLANT) and c:IsFaceup() and c:IsLevelBelow(3) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.spfilter2(c,e,tp,lv)
	return c:IsRace(RACE_PLANT) and c:IsFaceup() and c:IsLevel(lv) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.fselect(g,e,tp,tg)
	return tg:IsExists(cm.spfilter2,1,g,e,tp,#g)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(cm.rmfilter,tp,LOCATION_DECK,0,nil)
	local sg=Duel.GetMatchingGroup(cm.spfilter1,tp,LOCATION_DECK,0,nil,e,tp)
	local tg=Group.CreateGroup()
	for tc in aux.Next(sg) do
		if Duel.IsExistingMatchingCard(cm.rmfilter,tp,LOCATION_DECK,0,tc:GetLevel(),tc) then tg:AddCard(tc) end
	end
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		return #tg>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	end
	local tempg,ct=tg:GetMaxGroup(Card.GetLevel)
	SNNM.UpConfirm(tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local rg=g:SelectSubGroup(tp,cm.fselect,false,1,ct,e,tp,tg)
	Duel.ConfirmCards(1-tp,rg)
	Duel.Remove(rg,POS_FACEDOWN,REASON_COST)
	Duel.SetTargetParam(#rg)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local lv=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.spfilter2,tp,LOCATION_DECK,0,1,1,nil,e,tp,lv)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
