--破晓连结 日和莉
function c10700233.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,nil,2,2,c10700233.lcheck)
	c:EnableReviveLimit()
	--link
	local e0=Effect.CreateEffect(c)  
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)  
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)  
	e0:SetCode(EVENT_SPSUMMON_SUCCESS)  
	e0:SetCondition(c10700233.lkcon)  
	e0:SetOperation(c10700233.lkop)  
	c:RegisterEffect(e0)   
	--atk
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c10700233.atkval)
	c:RegisterEffect(e1)	
	--attack twice
	--local e2=Effect.CreateEffect(c)
	--e2:SetType(EFFECT_TYPE_SINGLE)
	--e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	--e2:SetRange(LOCATION_MZONE)
	--e2:SetCode(EFFECT_EXTRA_ATTACK_MONSTER)
	--e2:SetValue(1)
	--c:RegisterEffect(e2)
	--poschange
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_POSITION)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_BATTLE_START)
	e3:SetCondition(c10700233.defcon)
	e3:SetCondition(c10700233.poscon)
	e3:SetTarget(c10700233.postg)
	e3:SetOperation(c10700233.posop)
	c:RegisterEffect(e3)
	--pierce
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_PIERCE)
	e4:SetCondition(c10700233.defcon2)
	c:RegisterEffect(e4)
end
function c10700233.lcheck(g,lc)
	return g:IsExists(c10700233.mzfilter,1,nil)
end
function c10700233.mzfilter(c)
	return c:IsLinkSetCard(0x3a01) and not c:IsLinkType(TYPE_LINK)
end
function c10700233.lkcon(e,tp,eg,ep,ev,re,r,rp)  
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)  
end  
function c10700233.lkop(e,tp,eg,ep,ev,re,r,rp)  
	Debug.Message("好了！该我登场了")
	Debug.Message("要让大家笑口常开！日和莉会努力的！耶！")
end
function c10700233.atkval(e,c)
	return c:GetLinkedGroupCount()*500
end
function c10700233.defcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsLinkState() and e:GetHandler():GetMutualLinkedGroupCount()==0
end
function c10700233.poscon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return bc and bc:IsPosition(POS_FACEUP_ATTACK) and not bc:IsType(TYPE_LINK)
end
function c10700233.postg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_POSITION,e:GetHandler():GetBattleTarget(),1,0,0)
end
function c10700233.posop(e,tp,eg,ep,ev,re,r,rp)
	local bc=e:GetHandler():GetBattleTarget()
	if bc:IsRelateToBattle() then
		Duel.ChangePosition(bc,POS_FACEUP_DEFENSE)
	end
end
function c10700233.defcon2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetMutualLinkedGroupCount()>0
end