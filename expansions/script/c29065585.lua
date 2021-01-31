--煌·沸腾爆裂
function c29065585.initial_effect(c)
	c:EnableCounterPermit(0x87ae)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x87af),8,2)
	c:EnableReviveLimit()
	--lv change
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_XYZ_LEVEL)
	e1:SetProperty(EFFECT_FLAG_SET_AVAIABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(c29065585.lvtg)
	e1:SetValue(c29065585.lvval)
	c:RegisterEffect(e1)
	--code
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_CHANGE_CODE)
	e2:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	e2:SetValue(29065584)
	c:RegisterEffect(e2) 
	--Destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(29065585,0))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetTarget(c29065585.stgtarget)
	e3:SetOperation(c29065585.stgoperation)
	c:RegisterEffect(e3) 
	--indes
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e4:SetRange(LOCATION_MZONE)
	e4:SetValue(c29065585.indct)
	c:RegisterEffect(e4)		
	--
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_CHAIN_SOLVING)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(c29065585.discon)
	e4:SetOperation(c29065585.disop)
	c:RegisterEffect(e4)
	--
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e6:SetCode(EVENT_SPSUMMON_SUCCESS)
	e6:SetOperation(c29065585.lrop)
	c:RegisterEffect(e6)
end
function c29065585.lvtg(e,c)
	return c:IsLevelAbove(1) and c:GetCounter(0x87ae)>0 and c:IsSetCard(0x87af)
end
function c29065585.lvval(e,c,rc)
	local lv=c:GetLevel()
	if rc==e:GetHandler() then return 8
	else return lv end
end
function c29065585.dfil(c,atk)
	return c:IsFaceup() and c:IsAttackBelow(atk)
end
function c29065585.stgtarget(e,tp,eg,ep,ev,re,r,rp,chk)
	local atk=e:GetHandler():GetAttack()
	if chk==0 then return e:GetHandler():GetOverlayGroup():IsExists(Card.IsCode,1,nil,29065584) and Duel.GetMatchingGroupCount(c29065585.dfil,tp,0,LOCATION_MZONE,nil,atk)>=1 end
	local g=Duel.GetMatchingGroup(c29065585.dfil,tp,0,LOCATION_MZONE,nil,atk)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c29065585.stgoperation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local atk=e:GetHandler():GetAttack()
	local g=Duel.GetMatchingGroup(c29065585.dfil,tp,0,LOCATION_MZONE,nil,atk)
	local x=Duel.Destroy(g,REASON_EFFECT)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(x*500)
	e1:SetRange(LOCATION_MZONE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e1)
	Duel.Damage(tp,x*500,REASON_EFFECT)
end
function c29065585.indct(e,re,r,rp)
	if bit.band(r,REASON_BATTLE+REASON_EFFECT)~=0 then
		return 1
	else return 0 end
end
function c29065585.discon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return re:GetHandler():GetControler()~=tp and e:GetHandler():GetOverlayGroup():IsExists(Card.IsCode,1,nil,29065584) and (ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE)
end
function c29065585.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end
function c29065585.lrop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ) then return false end
	Debug.Message("血源沸腾的热流，滚动的炽热火花！热情！膨胀！大爆发！")
	Debug.Message("XYZ召唤！RANK 8！煌•沸腾爆裂！")
end







