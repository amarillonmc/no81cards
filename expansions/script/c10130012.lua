--量子驱动 后勤工蜂群
if not pcall(function() require("expansions/script/c10130001") end) then require("script/c10130001") end
local s,id = GetID()
function s.initial_effect(c)
	local e1,e2 = Scl.CreateSingleTriggerOptionalEffect(c, "BeNormalSummoned,BeFlippedFaceup", "NormalSummon/Set", {1,id}, "NormalSummon/Set",nil,nil,nil,{ "~Target", "NormalSummon/Set",s.sumfilter,"Hand,MonsterZone" },s.sumop)
	Scl_Quantadrive.CreateNerveContact(s, e1)
end
function s.sumfilter(c)
	return c:IsSetCard(0xa336) and (c:IsSummonable(true, nil) or c:IsMSetable(true, nil))
end
function s.sumop(e,tp)
	Scl_Quantadrive.Summon =  Scl_Quantadrive.Summon + 1
	Scl_Quantadrive.Summon_Buff[Scl_Quantadrive.Summon] = s.sumop2
end
function s.sumop2(hc, e,tp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_MSET)
	e1:SetReset(RESET_EP_SCL)
	e1:SetOperation(s.buff)
	e1:SetLabel(hc:GetFieldID())
	e1:SetLabelObject(hc)
	Duel.RegisterEffect(e1,tp)
end
function s.buff(e, tp, eg)
	local tc = e:GetLabelObject()
	if tc and eg:IsContains(tc) and tc:GetFlagEffect(10130101) > 0 and tc:GetFlagEffectLabel(10130101) == e:GetLabel() then
		local e1 = Scl.CreateIgnitionEffect({tc,tc,true}, "ChangePosition", nil, "ChangePosition", "SetAvailable", "MonsterZone", nil, s.cpcost, { "~Target", "ChangePosition", s.cpfilter,"MonsterZone" }, s.cpop, RESETS_SCL)
	end
	e:Reset()
end
function s.cpcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c = e:GetHandler()
	if chk==0 then return c:IsFacedown() end
	local pos = Duel.SelectPosition(tp, c, POS_FACEUP)
	Duel.ChangePosition(c,pos)
end
function s.cpfilter(c)
	return c:IsCanChangePosition()
end
function s.cpop(e,tp)
	local _,tc = Scl.SelectCards("ChangePosition",tp,s.cpfilter,tp,"MonsterZone",0,1,1,nil)
	if not tc then return end
	local pos = Duel.SelectPosition(tp,tc,POS_FACEUP+POS_FACEDOWN_DEFENSE - tc:GetPosition())
	Duel.ChangePosition(tc, pos)
end