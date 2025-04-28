--创导龙裔的转生
dofile("expansions/script/c20000450.lua")
local cm, m = fuef.initial(fu_GD)
cm.e1 = fuef.A():CAT("SP"):Func("tg1,op1")
cm.e2 = fuef.FC(EFFECT_DESTROY_REPLACE):RAN("G"):Func("val2,tg2,op2")
--e1
function cm.tg1ff(g,tp,c,lv)
	Duel.SetSelectedCard(g)
	return g:IsExists(Card.IsRace,nil,1,RACE_SPELLCASTER) and g:CheckWithSumGreater(Card.GetRitualLevel,lv,c)
		and Duel.GetMZoneCount(tp,g,tp)>0 and (not c.mat_group_check or c.mat_group_check(g,tp))
end
function cm.tg1f(rc,e,tp,mg)
	if not fucf.Filter(rc, "IsTyp+IsSet+CanSp", "RI+M,3fd4", {e, SUMMON_TYPE_RITUAL, tp, false, true}) then return false end
	mg = mg:Filter(Card.IsCanBeRitualMaterial, rc, rc):Filter(rc.mat_filter or aux.TRUE, rc, tp)
	return mg:CheckSubGroup(cm.tg1ff,1,#mg,tp,rc,rc:GetLevel())
end
function cm.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return fugf.GetFilter(tp,"HD",cm.tg1f,{e,tp,Duel.GetRitualMaterial(tp)},1) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_HAND)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local mg = Duel.GetRitualMaterial(tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc = fugf.Select(tp,"HD",cm.tg1f,{e,tp,mg}):GetFirst()
	if not tc then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	mg = fugf.Filter(mg,"IsCanBeRitualMaterial+Not+%1","%2,%2,%3",nil,(tc.mat_filter or aux.TRUE),tc,tp)
	mg = mg:SelectSubGroup(tp,cm.tg1ff,false,1,#mg,tp,tc,tc:GetLevel())
	tc:SetMaterial(mg)
	Duel.ReleaseRitualMaterial(mg)
	Duel.BreakEffect()
	Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
	tc:CompleteProcedure()
	if #mg == 1 then fuef.S(e,EFFECT_INDESTRUCTABLE_EFFECT,tc):DES(m,0):PRO("SR+CD+HINT"):RAN("M"):VAL(1):RES("STD") end
	if mg:IsExists(Card.IsSetCard,nil,1,0xbfd4) then fuef.S(e,EFFECT_CANNOT_BE_EFFECT_TARGET,tc):DES(m,1):PRO("HINT"):VAL("tgoval"):RES("STD") end
end
--e2
function cm.val2(e,c)
	return fucf.Filter(c,"IsPos+IsTyp+IsRac+IsRea+IsLoc+IsCon","FU,RI+M,DR,EFF+BAT-REP,M",e:GetHandlerPlayer())
end
function cm.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemove() 
		and fugf.Filter(eg,"IsPos+IsTyp+IsRac+IsRea+IsLoc+IsCon","FU,RI+M,DR,EFF+BAT-REP,M,"..tp,1) end
	return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)
end


























