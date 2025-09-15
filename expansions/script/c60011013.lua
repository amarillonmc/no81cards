--圣剑 灿然辉耀的王剑-对吾华丽父王的叛逆
local s,m=GetID()
function s.initial_effect(c)
	--Cannot have another copy
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UNIQUE_CHECK)
	e1:SetRange(LOCATION_SZONE)
	e1:SetTargetRange(LOCATION_SZONE,0)
	e1:SetValue(s.uniqueval)
	c:RegisterEffect(e1)
	--Public continuous effect
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_PUBLIC)
	e2:SetCondition(s.pubcon)
	c:RegisterEffect(e2)
	--ATK boost effect
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetRange(LOCATION_HAND)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x107a))
	e3:SetValue(500)
	e3:SetCondition(s.pubcon)
	c:RegisterEffect(e3)
	--Return to deck and special summon effect
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_HAND)
	e4:SetCountLimit(1)
	e4:SetCondition(s.pubcon)
	e4:SetTarget(s.rttg)
	e4:SetOperation(s.rtop)
	c:RegisterEffect(e4)
	--Send to GY effect
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_TODECK)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_TO_GRAVE)
	e5:SetProperty(EFFECT_FLAG_DELAY)
	e5:SetCountLimit(1,m)
	e5:SetCondition(s.sgcon)
	e5:SetTarget(s.sgtg)
	e5:SetOperation(s.sgop)
	c:RegisterEffect(e5)
end

function s.uniqueval(e,c)
	return c:IsCode(e:GetHandler():GetCode())
end

function s.pubcon(e)
	return e:GetHandler():IsPublic()
end

function s.rtfilter(c)
	return c:IsSetCard(0x107a) and (c:IsLocation(LOCATION_HAND) or c:IsLocation(LOCATION_GRAVE)) and c:IsAbleToDeck()
end

function s.spfilter(c,e,tp)
	return c:IsSetCard(0x107a) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end

function s.rttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.rtfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,0,tp,LOCATION_DECK)
end

function s.rtop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,s.rtfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 and Duel.SendtoDeck(g,nil,SEQ_DECKTOP,REASON_EFFECT)~=0 then
		local sg=Group.CreateGroup()
		for i=1,5 do
			local tc=Duel.GetDecktopGroup(tp,1):GetFirst()
			if tc and not sg:IsExists(Card.IsCode,1,nil,tc:GetCode()) then
				sg:AddCard(tc)
				if tc:IsSetCard(0x107a) then break end
			else
				break
			end
		end
		if sg:GetCount()>0 then
			Duel.ConfirmCards(tp,sg)
			local spg=sg:Filter(s.spfilter,nil,e,tp)
			if spg:GetCount()>0 then
				Duel.SpecialSummon(spg,0,tp,tp,false,false,POS_FACEUP)
			end
			Duel.ShuffleDeck(tp)
		end
	end
end

function s.sgcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_HAND)
end

function s.sgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_GRAVE,0)>0 end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,0,tp,LOCATION_GRAVE)
end

function s.sgop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,LOCATION_GRAVE,0)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local sg=g:Select(tp,1,5,nil)
		Duel.SendtoDeck(sg,nil,SEQ_DECKTOP,REASON_EFFECT)
	end
end

