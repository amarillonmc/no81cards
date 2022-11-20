--孤注一掷！
function c10113005.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DICE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetCondition(c10113005.condition)
	e1:SetOperation(c10113005.activate)
	c:RegisterEffect(e1)	
end 

function c10113005.condition(e,tp,eg,ep,ev,re,r,rp)
	local at=Duel.GetAttacker()
	return at:GetControler()~=tp and Duel.GetAttackTarget()==nil and at:GetAttack()>=Duel.GetLP(tp)
end

function c10113005.activate(e,tp,eg,ep,ev,re,r,rp)
	local d=Duel.TossDice(tp,1)
	--local WIN_REASON_DEATHDICE=0x55
	if d==5 then
	  Duel.SetLP(1-tp,0)
	  --Duel.Win(tp,WIN_REASON_DEATHDICE)
	else  --Duel.Win(1-tp,WIN_REASON_DEATHDICE)
	  Duel.SetLP(tp,0)
	end
end