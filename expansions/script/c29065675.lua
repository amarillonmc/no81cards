--灵知隐者 关士统领王牌
function c29065675.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkSetCard,0x87aa),2,3)
	--cannot target
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e1:SetValue(aux.tgoval)
	c:RegisterEffect(e1)	
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,29065675)
	e2:SetCondition(c29065675.spcon)
	e2:SetTarget(c29065675.sptg)
	e2:SetOperation(c29065675.spop)
	c:RegisterEffect(e2)
	--destroy
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_BATTLE_START)
	e4:SetCountLimit(1,29000037)
	e4:SetCondition(c29065675.descon)
	e4:SetTarget(c29065675.destg)
	e4:SetOperation(c29065675.desop)
	c:RegisterEffect(e4)
end
function c29065675.cfilter(c,lg)
	return c:IsSetCard(0x87aa) and lg:IsContains(c)
end
function c29065675.spcon(e,tp,eg,ep,ev,re,r,rp)
	local lg=e:GetHandler():GetLinkedGroup()
	return eg:IsExists(c29065675.cfilter,1,nil,lg)
end
function c29065675.desfil(c,e,tp,lg)
	return lg:IsContains(c) and Duel.IsExistingMatchingCard(c29065675.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp)
end
function c29065675.spfilter(c,e,tp)
	return c:IsSetCard(0x87aa) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP) 
end
function c29065675.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local lg=e:GetHandler():GetLinkedGroup()
	if chk==0 then return Duel.IsExistingMatchingCard(c29065675.desfil,tp,LOCATION_MZONE,0,1,nil,e,tp,lg) end
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,1,tp,LOCATION_MZONE)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c29065675.spop(e,tp,eg,ep,ev,re,r,rp)
	local lg=e:GetHandler():GetLinkedGroup()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local g=Duel.GetMatchingGroup(c29065675.spfilter,tp,LOCATION_DECK,0,nil,e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local dg=Duel.SelectMatchingCard(tp,c29065675.desfil,tp,LOCATION_MZONE,0,1,1,nil,e,tp,lg)
	if Duel.Destroy(dg,REASON_EFFECT) and g:GetCount()>0 then 
	sg=g:Select(tp,1,1,nil)
	Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c29065675.descon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return bc and bc:IsSummonType(SUMMON_TYPE_SPECIAL)
end
function c29065675.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler():GetBattleTarget(),1,0,0)
end
function c29065675.desop(e,tp,eg,ep,ev,re,r,rp)
	local bc=e:GetHandler():GetBattleTarget()
	if bc:IsRelateToBattle() then
		local atk=bc:GetTextAttack()
		if atk<0 then atk=0 end
		if Duel.Destroy(bc,REASON_EFFECT)~=0 then
			Duel.Damage(1-tp,atk,REASON_EFFECT)
		end
	end
end