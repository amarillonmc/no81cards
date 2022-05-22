--邪骨团 谬误
local m=64800138
local cm=_G["c"..m]
Duel.LoadScript("c64800135.lua")
function cm.initial_effect(c)
	local e0=Suyu_02_x.gi(c,m)
	local e1,e2=Suyu_02_x.geffect(c,m,cm.tg,cm.op,CATEGORY_SPECIAL_SUMMON,EFFECT_FLAG_CARD_TARGET)
end
cm.setname="Zx02"
function cm.filter(c,e,tp)
	return c:IsType(TYPE_SPELL+TYPE_CONTINUOUS) and bit.band(TYPE_MONSTER,c:GetOriginalType())~=0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_SZONE) and cm.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(cm.filter,tp,LOCATION_SZONE,LOCATION_SZONE,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,cm.filter,tp,LOCATION_SZONE,LOCATION_SZONE,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end