--创导龙裔的转生
dofile("expansions/script/c20000450.lua")
local cm, m = fusf.Initial(fu_GD)
--e1
cm.e1 = fuef.A():Cat("REL+SP"):Func("tg1,op1")
function cm.tg1f2(g, tp, c, lv)
	if #fugf.Filter(g, "IsRac", "SP") < 1 or Duel.GetMZoneCount(tp, g, tp) == 0 then return false end
	Duel.SetSelectedCard(g)
	return g:CheckWithSumGreater(Card.GetRitualLevel, lv, c) and (c.mat_group_check or aux.TRUE)(g, tp)
end
function cm.tg1f1(rc, e, tp, mg)
	if fucf.Filter(rc, "~(IsTyp+IsSet+CanSp)", "RI+M,3fd4,(%1,RI)", e) then return false end
	mg = mg:Filter(Card.IsCanBeRitualMaterial, rc, rc):Filter(rc.mat_filter or aux.TRUE, rc, tp)
	local lv = rc:GetLevel()
	aux.GCheckAdditional = aux.RitualCheckAdditional(rc, lv, "Greater")
	local res = mg:CheckSubGroup(cm.tg1f2, 1, math.min(#mg, lv), tp, rc, lv)
	aux.GCheckAdditional = nil
	return res
end
local e1g1 = fugf.MakeFilter("HD", cm.tg1f1, "%1,%2,%3")
function cm.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return #e1g1(tp, e, tp, Duel.GetRitualMaterial(tp)) > 0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_HAND)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local mg = Duel.GetRitualMaterial(tp)
	local rc, sg
	repeat
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		rc = fugf.Select(tp, e1g1(tp, e, tp, mg)):GetFirst()
		if not rc then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		sg = mg:Filter(Card.IsCanBeRitualMaterial, rc, rc):Filter(rc.mat_filter or aux.TRUE, rc, tp)
		local lv = rc:GetLevel()
		aux.GCheckAdditional = aux.RitualCheckAdditional(rc, lv, "Greater")
		sg = sg:SelectSubGroup(tp, cm.tg1f2, true, 1, math.min(#sg, lv), tp, rc, lv)
		aux.GCheckAdditional = nil
	until sg
	fu_GD.Hint(tp, m, sg, rc)
	rc:SetMaterial(sg)
	Duel.ReleaseRitualMaterial(sg)
	Duel.BreakEffect()
	Duel.SpecialSummon(rc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
	rc:CompleteProcedure()
	if #sg == 1 then
		fuef.S(e,EFFECT_INDESTRUCTABLE_EFFECT,rc):Des(1):Pro("IG+SR+CD+HINT"):Ran("M"):Val(1):Res("STD")
	end
	if #fugf.Filter(sg, "IsSet", "bfd4") > 0 then
		fuef.S(e,EFFECT_CANNOT_BE_EFFECT_TARGET,rc):Des(2):Pro("IG+HINT"):Val("tgoval"):Res("STD")
	end
end
--e2
cm.e2 = fuef.FC(EFFECT_DESTROY_REPLACE):Ran("G"):Func("val2,tg2,op2")
local e1f1 = fugf.MakeGroupFilter("IsPos+IsTyp+IsRac+IsRea+IsLoc+IsCon","FU,RI+M,DR,EFF+BAT-REP,M,%1")
function cm.val2(e,c)
	return e1f1(Group.FromCards(c), 1, e:GetHandlerPlayer())
end
function cm.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemove() and e1f1(eg, 1, tp) end
	return Duel.SelectEffectYesNo(tp, e:GetHandler(), 96)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Remove(e:GetHandler(), POS_FACEUP, REASON_EFFECT)
	Duel.Hint(HINT_CARD,0,m)
end