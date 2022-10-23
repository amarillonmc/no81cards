--灭剑炎龙·进攻形态
local m=48000014
local cm=_G["c"..m]

function cm.initial_effect(c)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(cm.flagcon)
	e1:SetOperation(cm.regop)
	c:RegisterEffect(e1)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_SPSUMMON_PROC)
	e3:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e3:SetRange(LOCATION_EXTRA)
	e3:SetValue(SUMMON_TYPE_SYNCHRO)
	e3:SetCondition(cm.sycon)
	e3:SetOperation(cm.syop)
	e3:SetLabelObject(e1)
	c:RegisterEffect(e3)
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,1))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,48000014)
	e1:SetCondition(cm.descon)
	e1:SetTarget(cm.destg)
	e1:SetOperation(cm.desop)
	c:RegisterEffect(e1)
	--atk
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,2))
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(cm.atkcon)
	e2:SetOperation(cm.atkop)
	c:RegisterEffect(e2)
	
end
function cm.stfilter1(c,tc,g)
	local tg=g:Clone()
	tg:RemoveCard(c)
	return c:IsPosition(POS_FACEUP) and c:IsCanBeSynchroMaterial(tc) and c:IsSynchroType(TYPE_TUNER) and c:IsRace(RACE_DRAGON) and tg:FilterCount(cm.stfilter2,nil,tc)==tg:GetCount()
end
function cm.stfilter2(c,tc)
	return c:IsCode(48000012) and c:GetFlagEffect(48000012)~=0 and c:IsCanBeSynchroMaterial(tc) and c:IsPosition(POS_FACEUP) 
end
function cm.stfilterg(g,tp,tc,smat)
	if smat then
		g:AddCard(smat)
	end
	return g:GetSum(Card.GetLevel)>=12  and Duel.GetLocationCountFromEx(tp,tp,g,tc)>0 and g:FilterCount(cm.stfilter1,nil,tc,g)>=1
end
function cm.sycon(e,c,smat,mg)
	if c==nil then return true end
	local tp=c:GetControler()
	if not mg then
		mg=Duel.GetMatchingGroup(nil,tp,LOCATION_MZONE,0,nil)
	end
	if smat then
		mg:RemoveCard(smat)
		return mg:CheckSubGroup(cm.stfilterg,1,nil,tp,c,smat)
	else
		return mg:CheckSubGroup(cm.stfilterg,2,nil,tp,c,nil)
	end
end
function cm.syop(e,tp,eg,ep,ev,re,r,rp,c,smat,mg)
	local lv=e:GetLabel()
	if not mg then
		mg=Duel.GetMatchingGroup(nil,tp,LOCATION_MZONE,0,nil)
	end
	local g=Group.CreateGroup()
	if smat then
		mg:RemoveCard(smat)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		g:Merge(mg:SelectSubGroup(tp,cm.stfilterg,false,1,nil,tp,c,smat))
		g:AddCard(smat)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		g:Merge(mg:SelectSubGroup(tp,cm.stfilterg,false,2,nil,tp,c,nil))
	end
	c:SetMaterial(g)
	local lvt=g:GetSum(Card.GetLevel)
	e:GetLabelObject():SetLabel(g:GetSum(Card.GetLevel)-12)
	Duel.SendtoGrave(g,REASON_MATERIAL+REASON_SYNCHRO)
end
function cm.flagcon(e)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO) and e:GetLabel()>1
end
function cm.regop(e,tp,eg,ep,ev,re,r,rp)
   local c=e:GetHandler()
   if e:GetLabel()>=6 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetDescription(aux.Stringid(m,0))
		e1:SetProperty(EFFECT_FLAG_CLIENT_HINT+EFFECT_FLAG_PLAYER_TARGET)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetRange(LOCATION_MZONE)
		e1:SetAbsoluteRange(ep,0,1)
		c:RegisterEffect(e1,true)
		c:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,0,1)
	end
	if e:GetLabel()>=1 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(800)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1)
	end
	if e:GetLabel()>=4 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
		c:RegisterEffect(e1)
	end
end
function cm.desfilter1(c)
	return c:IsFaceup() and (c:IsLevelBelow(4) or c:IsRankBelow(4) or c:IsLinkBelow(2))
end
function cm.desfilter2(c)
	return c:IsFaceup() and (c:IsLevelBelow(8) or c:IsRankBelow(8) or c:IsLinkBelow(4))
end
function cm.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.desfilter1,tp,0,LOCATION_MZONE,1,nil) or (Duel.IsExistingMatchingCard(cm.desfilter2,tp,0,LOCATION_MZONE,1,nil) and e:GetHandler():GetFlagEffect(48000014)~=0) end
	if e:GetHandler():GetFlagEffect(48000014)~=0 then
		local g=Duel.GetMatchingGroup(desfilter2,tp,0,LOCATION_MZONE,nil)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
	else 
		local g=Duel.GetMatchingGroup(desfilter1,tp,0,LOCATION_MZONE,nil)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
	end
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():GetFlagEffect(48000014)~=0 then
		local g=Duel.GetMatchingGroup(desfilter2,tp,0,LOCATION_MZONE,nil)
		if g:GetCount()>0 then
			Duel.Destroy(g,REASON_EFFECT)
		end
	else 
		local g=Duel.GetMatchingGroup(desfilter1,tp,0,LOCATION_MZONE,nil)
		if g:GetCount()>0 then
			Duel.Destroy(g,REASON_EFFECT)
		end
	end
end
function cm.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local at=Duel.GetAttacker()
	return at:IsControler(tp) and (at:IsRace(RACE_DRAGON) or at:IsRace(RACE_WARRIOR))
end
function cm.atkop(e,tp,eg,ep,ev,re,r,rp)
	local at=Duel.GetAttacker()
	if at:IsFaceup() and at:IsRelateToBattle() then
		if e:GetHandler():GetFlagEffect(48000014)~=0 then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(800)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			at:RegisterEffect(e1)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_DEFENSE)
			e1:SetValue(800)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			at:RegisterEffect(e1)
		else 
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(400)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			at:RegisterEffect(e1)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_DEFENSE)
			e1:SetValue(400)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			at:RegisterEffect(e1)
		end
	end
end