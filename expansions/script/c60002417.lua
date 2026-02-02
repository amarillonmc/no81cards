--瀚海晏霞 真珠之智
local cm,m,o=GetID()
function cm.initial_effect(c)
	c:SetSPSummonOnce(m)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_EFFECT),2,2,cm.lcheck)
	c:EnableReviveLimit()
	--tohand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(cm.thcon1)
	e1:SetTarget(cm.thtg1)
	e1:SetOperation(cm.thop1)
	c:RegisterEffect(e1)
	--search
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(cm.thtg)
	e3:SetOperation(cm.thop)
	c:RegisterEffect(e3)
end
function cm.lcheck(g)
	return g:IsExists(Card.IsLinkAttribute,1,nil,ATTRIBUTE_WATER)
end
function cm.thcon1(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function cm.thfilter1(c)
	return c:IsSetCard(0x6622) and c:IsAbleToRemove()
end
function cm.thtg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter1,tp,LOCATION_DECK,0,1,nil) end
end
function cm.thop1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,cm.thfilter1,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		if Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)~=0 then
			local rg=Duel.GetDecktopGroup(tp,1)
			Duel.Remove(rg,POS_FACEDOWN,REASON_EFFECT)
		end
	end
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=6 end
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local aa={}
	for i=1,math.min(3,Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)) do
		aa[i]=i
	end
	local num=Duel.AnnounceNumber(tp,table.unpack(aa))
	local g=Duel.GetDecktopGroup(tp,num)
	if Duel.Remove(g,POS_FACEUP,REASON_EFFECT)~=0 then
		local aa={}
		for i=1,math.min(3,Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)) do
			aa[i]=i
		end
		local num=Duel.AnnounceNumber(tp,table.unpack(aa))
		local g=Duel.GetDecktopGroup(tp,num)
		if Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)~=0 and Duel.SelectEffectYesNo(tp,aux.Stringid(m,1)) then
			local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_REMOVED,0,nil)
			local qg=Duel.GetMatchingGroup(Card.IsFacedown,tp,LOCATION_REMOVED,0,nil)
			Duel.ConfirmCards(tp,qg)
			g:Merge(qg)
			local tc=g:Select(tp,1,1,nil):GetFirst()
			if tc:IsType(TYPE_MONSTER) and tc:IsAttribute(ATTRIBUTE_WATER) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and tc:IsCanBeSpecialSummoned(e,0,tp,false,false) then
				Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
			else
				Duel.SendtoHand(tc,tp,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,tc)
			end
		end
	end
end



