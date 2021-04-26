--异梦迷宫的狐面武士-师傅
xpcall(function() require("expansions/script/c71400001") end,function() require("script/c71400001") end)
function c71400012.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,yume.YumeCheck(c),aux.NonTuner(yume.YumeCheck(c)),1)
	c:EnableReviveLimit()
	--summon limit
	yume.AddYumeSummonLimit(c,1)
	--immune
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetValue(c71400012.filter1)
	c:RegisterEffect(e1)
	--banish
	local e2a=Effect.CreateEffect(c)
	e2a:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2a:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2a:SetCode(EVENT_CHAINING)
	e2a:SetRange(LOCATION_MZONE)
	e2a:SetOperation(aux.chainreg)
	c:RegisterEffect(e2a)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_CHAIN_SOLVING)
	e2:SetOperation(c71400012.op2)
	c:RegisterEffect(e2)
	--banish
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(71400012,0))
	e3:SetCategory(CATEGORY_REMOVE+CATEGORY_DAMAGE+CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_BATTLE_START)
	e3:SetTarget(c71400012.tg3)
	e3:SetOperation(c71400012.op3)
	c:RegisterEffect(e3)
end
function c71400012.filter1(e,te)
	local c=e:GetHandler()
	local ec=te:GetHandler()
	if ec:IsHasCardTarget(c) then return true end
	return te:IsHasType(EFFECT_TYPE_ACTIONS) and te:IsHasProperty(EFFECT_FLAG_CARD_TARGET) and c:IsRelateToEffect(te)
end
function c71400012.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetFlagEffect(1)==0 then return end
	if not re:IsActiveType(TYPE_EFFECT) or not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	if g and g:IsContains(c) then
		local mg=Duel.GetMatchingGroup(Card.IsAbleToRemove,rp,LOCATION_MZONE,0,c,tp)
		if mg:GetCount()==0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local sg=mg:Select(tp,1,1,nil)
		if Duel.Destroy(sg,REASON_EFFECT,LOCATION_REMOVED)>0 then
			Duel.Damage(rp,2000,REASON_EFFECT)
		end
	end
end
function c71400012.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=e:GetHandler():GetBattleTarget()
	if chk==0 then return tc and tc:IsAbleToRemove() end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,tc,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,tc,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,tc:GetControler(),2000)
end
function c71400012.op3(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler():GetBattleTarget()
	if tc then
		local bp=tc:GetControler()
		if tc:IsRelateToBattle() and Duel.Destroy(tc,REASON_EFFECT,LOCATION_REMOVED)>0 then
			Duel.Damage(bp,2000,REASON_EFFECT)
		end
	end
end