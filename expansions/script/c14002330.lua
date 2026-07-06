--星辰之梦像 哈斯塔
local m=14002330
local cm=_G["c"..m]
cm.named_with_Hastur=1
function cm.initial_effect(c)
	--Synchro
	c:EnableReviveLimit()
	aux.AddSynchroMixProcedure(c,aux.Tuner(nil),nil,nil,cm.synmatfilter,1,99)
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(m,0))
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCondition(cm.stsyncon)
	e0:SetTarget(cm.stsyntg)
	e0:SetOperation(cm.stsynop)
	e0:SetValue(SUMMON_TYPE_SYNCHRO)
	c:RegisterEffect(e0)
	--actlimit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(0,1)
	e1:SetCondition(cm.actcon)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--rep
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_SEND_REPLACE)
	e2:SetRange(0xff)
	e2:SetTarget(cm.reptg)
	e2:SetValue(cm.repval)
	c:RegisterEffect(e2)
end
function cm.Urara(c)
	local m_code=_G["c"..c:GetCode()]
	return m_code and m_code.named_with_Urara
end
function cm.Hastur(c)
	local m_code=_G["c"..c:GetCode()]
	return m_code and m_code.named_with_Hastur
end
function cm.synmatfilter(c)
	return c:IsType(TYPE_TOKEN) or c:IsType(TYPE_SYNCHRO)
end
function cm.stsynfilter(c,syncard)
	return c:IsFaceup() and c:IsCanBeSynchroMaterial(syncard) and cm.synmatfilter(c)
end
function cm.stsyngoal(g,target_lv,syncard)
	return g:GetSum(Card.GetSynchroLevel,syncard)==target_lv
end
function cm.stsyncon(e,c)
	if c==nil then return true end
	if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
	local tp=c:GetControler()
	local lv=c:GetLevel()
	local remain=lv-1
	if remain<=0 then return false end
	if not Duel.IsCanRemoveCounter(tp,1,1,0x1402,1,REASON_MATERIAL) then return false end
	local mg=Duel.GetMatchingGroup(cm.stsynfilter,tp,LOCATION_MZONE,0,nil,c)
	return mg:CheckSubGroup(cm.stsyngoal,1,99,remain,c)
end
function cm.stsyntg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local lv=c:GetLevel()
	local remain=lv-1
	local mg=Duel.GetMatchingGroup(cm.stsynfilter,tp,LOCATION_MZONE,0,nil,c)
	local cancel=Duel.IsSummonCancelable()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
	local tg=mg:SelectSubGroup(tp,cm.stsyngoal,cancel,1,99,remain,c)
	if tg then
		tg:KeepAlive()
		e:SetLabelObject(tg)
		return true
	else
		return false
	end
end
function cm.stsynop(e,tp,eg,ep,ev,re,r,rp,c)
	local tg=e:GetLabelObject()
	if not tg then return end
	Duel.RemoveCounter(tp,1,1,0x1402,1,REASON_MATERIAL+REASON_SYNCHRO)
	c:SetMaterial(tg)
	Duel.SendtoGrave(tg,REASON_MATERIAL+REASON_SYNCHRO)
	tg:DeleteGroup()
end
function cm.actcon(e)
	local ph=Duel.GetCurrentPhase()
	return (ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE) or ph==PHASE_MAIN2
end
function cm.xyzfilter(c,e,tp,mc)
	if not (c:IsType(TYPE_XYZ) and c:IsAttribute(ATTRIBUTE_WIND) and c:IsRankBelow(9) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)) then return false end
	local b=false
	if mc:IsLocation(LOCATION_MZONE) then
		b=Duel.GetLocationCountFromEx(tp,tp,mc,c)>0
	else
		b=Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
	end
	if not b then return false end
	local is_theme=cm.Urara(c) or cm.Hastur(c)
	if not is_theme and not Duel.IsCanRemoveCounter(tp,1,1,0x1402,2,REASON_COST) then return false end
	return true
end
function cm.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return bit.band(r,REASON_COST)~=0 and re and re:GetLabel()==14002381
			and eg:IsContains(c) and (c:GetDestination()==LOCATION_DECK or c:GetDestination()==LOCATION_EXTRA)
			and Duel.IsExistingMatchingCard(cm.xyzfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,c)
	end
	if Duel.SelectYesNo(tp, aux.Stringid(m,1)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g = Duel.SelectMatchingCard(tp,cm.xyzfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,c)
		local tc = g:GetFirst()
		if tc then
			local is_theme=cm.Urara(tc) or cm.Hastur(tc)
			if not is_theme then
				Duel.RemoveCounter(tp,1,1,0x1402,2,REASON_COST)
			end
			local mg = c:GetOverlayGroup()
			if mg:GetCount()~=0 then
				Duel.Overlay(tc, mg)
			end
			tc:SetMaterial(Group.FromCards(c))
			Duel.Overlay(tc, Group.FromCards(c))
			Duel.SpecialSummon(tc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
			tc:CompleteProcedure()
		end
		return true
	end
	return false
end
function cm.repval(e,c)
	return c==e:GetHandler()
end