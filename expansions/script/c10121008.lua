--暗黑天使 衣卒尔
if not pcall(function() require("expansions/script/c10121001") end) then require("script/c10121001") end
function c10121008.initial_effect(c)
	rsdio.AngelHandXyzEffect(c,true)
	--xyzlv
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_XYZ_LEVEL)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE+LOCATION_HAND)
	e1:SetValue(c10121008.xyzlv)
	--c:RegisterEffect(e1)
	--todeck
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10121008,0))
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,10121008)
	e2:SetTarget(c10121008.target)
	e2:SetOperation(c10121008.operation)
	c:RegisterEffect(e2)
end
function c10121008.xyzlv(e,c,rc)
	local lv=e:GetHandler():GetLevel()
	if rc:IsSetCard(0xa331) or rc:IsSetCard(0xc331) then
		return 0x100000+lv
	else
		return lv
	end
end
function c10121008.filter(c)
	return (c:IsSetCard(0xa331) or c:IsSetCard(0xc331)) and c:IsType(TYPE_MONSTER) and c:IsAbleToDeck()
end
function c10121008.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c10121008.filter(chkc) and chkc~=c end
	if chk==0 then return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c10121008.filter,tp,LOCATION_GRAVE,0,5,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c10121008.filter,tp,LOCATION_GRAVE,0,5,5,c)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,5,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,tp,LOCATION_GRAVE+LOCATION_HAND)
end
function c10121008.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if not tg or tg:FilterCount(Card.IsRelateToEffect,nil,e)~=5 then return end
	Duel.SendtoDeck(tg,nil,0,REASON_EFFECT)
	local g=Duel.GetOperatedGroup()
	if g:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then Duel.ShuffleDeck(tp) end
	local ct=g:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)
	if ct==5 and c:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
	   Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c10121008.xyzlv(e,c,rc)
	local lv=e:GetHandler():GetLevel()
	if rc:IsSetCard(0xa331) or rc:IsSetCard(0x331) then return 0xa0000+lv 
	else return lv
	end
end