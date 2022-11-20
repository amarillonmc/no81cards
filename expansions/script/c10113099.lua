--陷阱塔
function c10113099.initial_effect(c)
	--Destroy
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetTarget(c10113099.target)
	e1:SetOperation(c10113099.activate)
	c:RegisterEffect(e1)	
end
function c10113099.filter(c,tp)
	return c:IsLocation(LOCATION_MZONE) and c:GetSummonPlayer()==tp and bit.band(c:GetSummonLocation(),LOCATION_DECK+LOCATION_EXTRA)~=0
end
function c10113099.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c10113099.filter,1,nil,1-tp) and Duel.IsPlayerCanSpecialSummonMonster(tp,10113099,0,0x11,0,3000,6,RACE_FIEND,ATTRIBUTE_DARK) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	local g=eg:Filter(c10113099.filter,nil,1-tp)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,LOCATION_SZONE)
end
function c10113099.activate(e,tp,eg,ep,ev,re,r,rp)
	local g,c=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e),e:GetHandler()
	if g:GetCount()>0 and Duel.Destroy(g,REASON_EFFECT)~=0 and c:IsRelateToEffect(e) and Duel.IsPlayerCanSpecialSummonMonster(tp,10113099,0,0x11,0,3000,6,RACE_FIEND,ATTRIBUTE_DARK) and  Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		c:AddMonsterAttribute(TYPE_NORMAL)
		Duel.SpecialSummonStep(c,0,tp,tp,true,false,POS_FACEUP_DEFENSE)
		--c:AddMonsterAttributeComplete()
		Duel.SpecialSummonComplete()
	end
end
