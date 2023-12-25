--幻梦无亘帝龙
xpcall(function() dofile("expansions/script/c20000000.lua") end,function() dofile("script/c20000000.lua") end)
local cm,m,o=GetID()
function cm.initial_effect(c)
	aux.AddCodeList(c,20000050,20000051)
	aux.EnableChangeCode(c,20000050,LOCATION_HAND+LOCATION_MZONE+LOCATION_GRAVE)
	fuef.QO(c,c,"CH,,NEGA+DES,DAM+CAL,M,1,con1,,tg1,op1")
end
--e1
function cm.con1(e,tp,eg,ep,ev,re,r,rp)
	local c,rc=e:GetHandler(),re:GetHandler()
	local g = fugf.Get(tp,"M+M"):GetMaxGroup(Card.GetBaseAttack)
	return re:IsActiveType(TYPE_MONSTER) and rc:IsOnField() and not c:IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev) and g and not g:IsContains(rc)
end
function cm.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local c,rc=e:GetHandler(),re:GetHandler()
	if Duel.NegateActivation(ev) and rc:IsRelateToEffect(re) and Duel.Destroy(rc,REASON_EFFECT)~=0 and rc:GetBaseAttack()>=0
		and c:IsRelateToEffect(e) and c:IsFaceup() then
		local atk = c:GetBaseAttack() + rc:GetBaseAttack()
		fuef.S(c,c,EFFECT_UPDATE_ATTACK,",,,"..(rc:GetBaseAttack())..",,,,EV+STD+PH/ED")
	end
end