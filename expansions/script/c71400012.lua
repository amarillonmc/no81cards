--梦之迷宫的剧面人
xpcall(function() require("expansions/script/c71400001") end,function() require("script/c71400001") end)
function c71400012.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,yume.YumeCheck(c),aux.NonTuner(yume.YumeCheck(c)),1)
	c:EnableReviveLimit()
	--summon limit
	yume.AddYumeSummonLimit(c,1)
	--cannot be target
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(aux.tgoval)
	c:RegisterEffect(e1)
	--banish
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(71400012,0))
	e2:SetCategory(CATEGORY_REMOVE+CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_BATTLE_START)
	e2:SetTarget(c71400012.target)
	e2:SetOperation(c71400012.operation)
	c:RegisterEffect(e2)
end
function c71400012.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=e:GetHandler():GetBattleTarget()
	if chk==0 then return tc and tc:IsControler(1-tp) and tc:IsAbleToRemove() and not tc:IsType(TYPE_TOKEN) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,tc,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,2000)
end
function c71400012.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.Damage(1-tp,2000,REASON_EFFECT)~=0 then
		local tc=e:GetHandler():GetBattleTarget()
		if tc:IsRelateToBattle() then
			Duel.Remove(tc,POS_FACEDOWN,REASON_EFFECT)
		end
	end
end