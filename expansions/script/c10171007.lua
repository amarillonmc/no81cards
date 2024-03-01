--灰烬黑焰 芙莉德
if not pcall(function() dofile("expansions/script/c10171001.lua") end) then dofile("script/c10171001.lua") end
local m,cm=rscf.DefineCard(10171007)
function cm.initial_effect(c)
	local e1=rsds.ExtraSummonFun(c,m+6)
	local e3=rsds.ChainingFun(c,m,nil,nil,cm.mvtg,cm.mvop)
	--tograve
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_ADJUST)
	e2:SetRange(LOCATION_MZONE)
	e2:SetOperation(cm.adjustop)
	c:RegisterEffect(e2)
end
function cm.tgfilter(c,tc)
	return tc:GetColumnGroup():IsContains(c) and c:GetSequence()<5
end
function cm.adjustop(e,tp)
	local phase=Duel.GetCurrentPhase()
	if (phase==PHASE_DAMAGE and not Duel.IsDamageCalculated()) or phase==PHASE_DAMAGE_CAL then return end
	local g=Duel.GetMatchingGroup(cm.tgfilter,tp,0,LOCATION_MZONE,nil,e:GetHandler())
	if Duel.SendtoGrave(g,REASON_EFFECT)>0 then
		Duel.Readjust()
	end
end
function cm.mvfilter(c)
	return c:GetSequence()<5
end
function cm.mvtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE,PLAYER_NONE,0)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,0,tp,LOCATION_HAND)
end
function cm.mvop(e,tp)
	local c=aux.ExceptThisCard(e)
	if not c or c:IsControler(1-tp) or c:IsImmuneToEffect(e)
		or Duel.GetLocationCount(tp,LOCATION_MZONE,PLAYER_NONE,0)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
	local s=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,0)
	local nseq=math.log(s,2)
	Duel.MoveSequence(c,nseq)
	--[[local g=Duel.GetMatchingGroup(rscf.spfilter2(Card.IsSetCard,0xa335),tp,LOCATION_HAND,0,nil,e,tp)
	if #g>0 and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
		rsgf.SelectSpecialSummon(g,tp,aux.TRUE,1,1,nil,{})
	end]]--
end