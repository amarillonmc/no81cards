--罗德岛·重装干员-石棉
function c79029217.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--equip
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetDescription(aux.Stringid(79029217,0))
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCondition(c79029217.eqcon)
	e1:SetTarget(c79029217.eqtg)
	e1:SetOperation(c79029217.eqop)
	c:RegisterEffect(e1)
	--Negate
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_NEGATE)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_CHAINING)
	e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1)
	e5:SetCondition(c79029217.discon)
	e5:SetCost(c79029217.discost)
	e5:SetTarget(c79029217.distg)
	e5:SetOperation(c79029217.disop)
	c:RegisterEffect(e5) 
	--damage
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(79029217,1))
	e2:SetCategory(CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_BATTLED)
	e2:SetCondition(c79029217.damcon)
	e2:SetTarget(c79029217.damtg)
	e2:SetOperation(c79029217.damop)
	c:RegisterEffect(e2)   
end
function c79029217.eqcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function c79029217.eqfilter(c,e,tp,x)
	local x=e:GetHandler():GetMaterialCount()
	return c:IsType(TYPE_LINK) and c:IsLinkBelow(x)
end
function c79029217.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local x=e:GetHandler():GetMaterialCount()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c79029217.eqfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,x) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_EXTRA)
end
function c79029217.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local x=e:GetHandler():GetMaterialCount()
	if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c79029217.eqfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,x)
	local tc=g:GetFirst()
	if tc then
	if not Duel.SendtoGrave(tc,REASON_EFFECT) then return end
	if e:GetHandler():IsPosition(POS_DEFENSE) then
	Duel.ChangePosition(e:GetHandler(),POS_FACEUP_ATTACK)   
	end
	Debug.Message("跟不上就自个找点事做吧。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029217,0))   
	e:GetHandler():SetCardData(CARDDATA_TYPE,TYPE_MONSTER+TYPE_LINK+TYPE_EFFECT)
	e:GetHandler():SetCardData(CARDDATA_LINK_MARKER,tc:GetLinkMarker())
	local x=tc:GetLink()
	e:GetHandler():SetCardData(CARDDATA_LEVEL,x)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_BASE_ATTACK)
	e1:SetValue(e:GetHandler():GetBaseAttack()+tc:GetBaseAttack())
	c:RegisterEffect(e1)
end
end
function c79029217.cfilter(c,e)
	return c:IsReleasable() and e:GetHandler():GetLinkedGroup():IsContains(c)
end
function c79029217.discon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev)
end
function c79029217.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c79029217.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,e) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectMatchingCard(tp,c79029217.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,e,tp)
	local tc=g:GetFirst()
	Duel.Release(tc,REASON_COST)
end
function c79029217.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function c79029217.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
	Duel.Destroy(eg,REASON_EFFECT)
	Debug.Message("吃屎去吧。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029217,1))   
end
function c79029217.damcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttacker()==e:GetHandler() and Duel.GetAttackTarget()
end
function c79029217.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,Duel.GetAttackTarget():GetBaseAttack())
end
function c79029217.damop(e,tp,eg,ep,ev,re,r,rp)
	local bc=Duel.GetAttackTarget()
	if bc and bc:IsRelateToBattle() and bc:IsFaceup() then
		Duel.Damage(1-tp,bc:GetBaseAttack(),REASON_EFFECT)
	Debug.Message("赏你们一门板。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029217,2))   
	end
end


























