--恶之数码兽 妖女兽
function c50223130.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,c50223130.ffilter1,c50223130.ffilter2,true)
	--double ATK
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_SET_ATTACK)
	e1:SetValue(c50223130.dbatk)
	e1:SetCondition(c50223130.con1)
	c:RegisterEffect(e1)
	--attack twices
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_DIRECT_ATTACK)
	e2:SetValue(1)
	e2:SetCondition(c50223130.con2)
	c:RegisterEffect(e2)
	--direct attack
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_EXTRA_ATTACK)
	e3:SetCondition(c50223130.con3)
	c:RegisterEffect(e3)
	--destroy
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_BATTLE_START)
	e4:SetCondition(c50223130.descon)
	e4:SetTarget(c50223130.destg)
	e4:SetOperation(c50223130.desop)
	c:RegisterEffect(e4)
end
function c50223130.ffilter1(c)
	return c:IsType(TYPE_FUSION)
end
function c50223130.ffilter2(c)
	return c:IsType(TYPE_RITUAL+TYPE_SYNCHRO+TYPE_XYZ+TYPE_LINK)
end
function c50223130.dbatk(e,c)
	local c=e:GetHandler()
	return c:GetBaseAttack()*2
end
function c50223130.valfilter1(c)
	return c:IsFusionType(TYPE_RITUAL) and c:IsFusionType(TYPE_MONSTER)
end
function c50223130.con1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local mg=c:GetMaterial()
	return mg:IsExists(c50223130.valfilter1,1,nil)
end
function c50223130.valfilter2(c)
	return c:IsFusionType(TYPE_SYNCHRO)
end
function c50223130.con2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local mg=c:GetMaterial()
	return mg:IsExists(c50223130.valfilter2,1,nil)
end
function c50223130.valfilter3(c)
	return c:IsFusionType(TYPE_XYZ)
end
function c50223130.con3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local mg=c:GetMaterial()
	return mg:IsExists(c50223130.valfilter3,1,nil)
end
function c50223130.valfilter4(c)
	return c:IsFusionType(TYPE_LINK)
end
function c50223130.descon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	local mg=c:GetMaterial()
	return mg:IsExists(c50223130.valfilter4,1,nil) and bc
end
function c50223130.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler():GetBattleTarget(),1,0,0)
end
function c50223130.desop(e,tp,eg,ep,ev,re,r,rp)
	local bc=e:GetHandler():GetBattleTarget()
	if bc:IsRelateToBattle() then
		Duel.Destroy(bc,REASON_EFFECT)
	end
end