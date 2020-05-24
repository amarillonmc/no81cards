--怒喰大怪兽 究极哥莫拉
if not pcall(function() require("expansions/script/c10199990") end) then require("script/c10199990") end
function c10150058.initial_effect(c)
	--link summon
	c:EnableReviveLimit() 
	aux.AddLinkProcedure(c,nil,2,99,c10150058.lcheck)
	local e1=rsef.FV_EXTRA_MATERIAL_SELF(c,"link",nil,aux.TargetBoolFunction(Card.IsLinkSetCard,0xd3),{0,LOCATION_MZONE }) 
	--sp
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10150058,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetHintTiming(0,0x1e0)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCountLimit(1,10150058)
	e1:SetCost(c10150058.spcost)
	e1:SetTarget(c10150058.sptg)
	e1:SetOperation(c10150058.spop)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10150058,1))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,10150158)
	e2:SetHintTiming(0,0x1e0)
	e2:SetTarget(c10150058.destg)
	e2:SetOperation(c10150058.desop)
	c:RegisterEffect(e2)
end
function c10150058.lcheck(g,lc)
	return g:IsExists(Card.IsSetCard,1,nil,0xd3)
end
function c10150058.desfilter(c,e,tp)
	return c:IsFaceup() and c:IsSetCard(0xd3)
end
function c10150058.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c10150058.desfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c10150058.desfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c10150058.desfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,LOCATION_MZONE)
end
function c10150058.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc,c=Duel.GetFirstTarget(),e:GetHandler()
	if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 and c:IsRelateToEffect(e) and c:IsFaceup() then
	   Duel.MajesticCopy(c,tc)
	end
end
function c10150058.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,1,0x37,2,REASON_COST) end
	Duel.RemoveCounter(tp,1,1,0x37,2,REASON_COST)
end
function c10150058.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c10150058.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end

