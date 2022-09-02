--天贯的骑士 加尔斯
local m=40009595
local cm=_G["c"..m]
cm.named_with_KeterSanctuary=1
function cm.KeterSanctuary(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_KeterSanctuary
end
function cm.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_EFFECT),2,2,cm.lcheck)
	c:EnableReviveLimit()  
	--tograve
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_SPECIAL_SUMMON+CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,m)
	e1:SetCondition(cm.spcon)
	e1:SetTarget(cm.sptg)
	e1:SetOperation(cm.spop)
	c:RegisterEffect(e1)  
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_MATERIAL_CHECK)
	e2:SetValue(cm.valcheck)
	e2:SetLabelObject(e1)
	c:RegisterEffect(e2) 
	--tohand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,1))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,40009596)
	e3:SetTarget(cm.target)
	e3:SetOperation(cm.activate)
	c:RegisterEffect(e3)  
end
function cm.lcfilter(c)
	return cm.KeterSanctuary(c)
end
function cm.lcheck(g,lc)
	return g:IsExists(cm.lcfilter,1,nil)
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK) and e:GetLabel()==1
end
function cm.spfilter(c,e,tp,ft)
	return cm.KeterSanctuary(c) and c:IsType(TYPE_MONSTER) and (c:IsAbleToHand() or (ft>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)))
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp,ft) end
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local g=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp,ft)
	local tc=g:GetFirst()
	if tc then
		if ft>0 and tc:IsCanBeSpecialSummoned(e,0,tp,false,false)
			and (not tc:IsAbleToHand() or Duel.SelectOption(tp,1190,1152)==1) then
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		else
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		end
	end
end

function cm.valcheck(e,c)
	local g=c:GetMaterial()
	if g:IsExists(Card.IsLevelAbove,1,nil,8) then
		e:GetLabelObject():SetLabel(1)
	else
		e:GetLabelObject():SetLabel(0)
	end
end
function cm.filter1(c)
	return c:IsRace(RACE_WARRIOR)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local g=Duel.GetMatchingGroup(cm.filter1,tp,LOCATION_DECK,0,nil)
		return g:GetClassCount(Card.GetCode)>=1
	end
end
function cm.filter(c)
	return c:IsFaceup() and c:IsLevelAbove(8)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetMatchingGroupCount(cm.filter,tp,LOCATION_MZONE,0,nil)
	if ct==0 then return end
	local g=Duel.GetMatchingGroup(cm.filter1,tp,LOCATION_DECK,0,nil)
	if g:GetClassCount(Card.GetCode)>=1 then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,2))
		local rg=g:SelectSubGroup(tp,aux.dncheck,false,1,ct)
		Duel.ConfirmCards(1-tp,rg)
		Duel.ShuffleDeck(tp)
		local tg=rg:GetFirst()
		while tg do
			Duel.MoveSequence(tg,0)
			tg=rg:GetNext()
		end
		Duel.SortDecktop(tp,tp,#rg)
	end
end
