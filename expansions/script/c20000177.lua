--忍警之圣沌 鸣子
dofile("expansions/script/c20000175.lua")
local cm, m = fu_HC.Initial()
--e1
cm.e1 = fuef.A():Cat("SP"):Func("tg1,op1")
local function CanSummon(tp)
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,m,0x5fd1,TYPES_NORMAL_TRAP_MONSTER,0,0,3,RACE_PSYCHO,ATTRIBUTE_LIGHT)
end
function cm.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:IsCostChecked() and CanSummon(tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not (c:IsRelateToEffect(e) and CanSummon(tp)) then return end
	c:AddMonsterAttribute(TYPE_NORMAL)
	Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP)
end
--e2
cm.e2 = fuef.STO("RE"):Pro("DE"):Func("tg2,op2")
function cm.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsSSetable() end
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local c = e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SSet(tp, c)
end