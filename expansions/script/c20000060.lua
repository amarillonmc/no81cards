--无亘皇帝之跃升
xpcall(function() dofile("expansions/script/c20000000.lua") end,function() dofile("script/c20000000.lua") end)
local cm,m,o=GetID()
function cm.initial_effect(c)
	fuef.A(c,EVENT_BATTLE_DESTROYED):CAT("SP"):Func("con1,tg1,op1")
end
--e1
function cm.con1(e,tp,eg,ep,ev,re,r,rp)
	local rc = eg:GetFirst():GetReasonCard()
	return rc:IsRelateToBattle() and rc:IsStatus(STATUS_OPPO_BATTLE) and rc:IsControler(tp) and rc:IsSetCard(0xbfd0)
end
function cm.tg1f1(c,e,tp,mc)
	if not fucf.Filter(c,"IsTyp+IsSet+CanSp", "RI+M,bfd0", {e,SUMMON_TYPE_RITUAL,tp,false,true}) then return false end
	return mc:IsCanBeRitualMaterial(c) and not c:IsCode(mc:GetCode())
end
function cm.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local rc = eg:GetFirst():GetReasonCard()
	if chk==0 then return fugf.GetFilter(tp,"HD",cm.tg1f1,{e,tp,rc},1) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local rc = eg:GetFirst():GetReasonCard()
	local bc = rc:GetBattleTarget()
	local atk = rc:GetBaseAttack() + bc:GetBaseAttack()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc = fugf.SelectFilter(tp,"HD",cm.tg1f1,{e,tp,rc}):GetFirst()
	if not tc then return end
	tc:SetMaterial(Group.FromCards(rc))
	Duel.ReleaseRitualMaterial(Group.FromCards(rc))
	Duel.BreakEffect()
	Duel.Hint(24,0,aux.Stringid(m,0)) 
	Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
	tc:CompleteProcedure()
	fuef.S(e,EFFECT_SET_BASE_ATTACK,{tc,1}):VAL(atk):RES("EV+STD")
end