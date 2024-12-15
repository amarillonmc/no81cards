--远古造物 金伯拉虫
dofile("expansions/script/c9910700.lua")
function c9910702.initial_effect(c)
	--flag
	QutryYgzw.AddTgFlag(c)
	--to grave
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCountLimit(1,9910702)
	e1:SetTarget(c9910702.tgtg)
	e1:SetOperation(c9910702.tgop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c9910702.tgcon)
	c:RegisterEffect(e2)
end
function c9910702.cfilter0(c)
	return c:IsFaceup() and c:IsSetCard(0xc950) and c:IsLevel(1) and c:IsLocation(LOCATION_MZONE)
end
function c9910702.tgfilter(c)
	local g=Group.FromCards(c)
	g:Merge(c:GetColumnGroup())
	return g:IsExists(c9910702.cfilter0,1,nil)
end
function c9910702.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c9910702.tgfilter,tp,0,LOCATION_ONFIELD,nil)
	local ct=g:GetCount()-1
	if chk==0 then return Duel.IsPlayerCanSendtoGrave(1-tp) and ct>0 and g:IsExists(Card.IsAbleToGrave,1,nil,1-tp,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,ct,0,0)
end
function c9910702.tgop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsPlayerCanSendtoGrave(1-tp) then return end
	local g=Duel.GetMatchingGroup(c9910702.tgfilter,tp,0,LOCATION_ONFIELD,nil)
	local ct=g:GetCount()-1
	if ct>0 then
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_TOGRAVE)
		local sg=g:FilterSelect(1-tp,Card.IsAbleToGrave,ct,ct,nil,1-tp,nil)
		Duel.SendtoGrave(sg,REASON_RULE)
	end
end
function c9910702.cfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0xc950) and c:IsControler(tp)
end
function c9910702.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return not eg:IsContains(e:GetHandler()) and eg:IsExists(c9910702.cfilter,1,nil,tp)
end
