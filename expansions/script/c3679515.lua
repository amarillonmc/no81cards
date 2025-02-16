--自然妖精·蒲公英
function c3679515.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,c3679515.matfilter,1,1)
	c:EnableReviveLimit()
	--synchro custom
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(3679515)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(1,0)
	c:RegisterEffect(e1)
	--force mzone
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_MUST_USE_MZONE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_EXTRA,LOCATION_EXTRA)
	e2:SetTarget(c3679515.target)
	e2:SetValue(c3679515.frcval)
	c:RegisterEffect(e2)
	--synchro summon
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(3679515,0))
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCondition(c3679515.syncon)
	e0:SetTarget(c3679515.syntg)
	e0:SetOperation(c3679515.synop)
	e0:SetValue(SUMMON_TYPE_SYNCHRO)
	--chain check
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAIN_ACTIVATING)
	e3:SetOperation(c3679515.chainop)
	Duel.RegisterEffect(e3,0)
	--
	if not c3679515.globle_check then
		c3679515.globle_check=true
		--synchro summon
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
		ge1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_SET_AVAILABLE)
		ge1:SetTargetRange(LOCATION_EXTRA,0)
		ge1:SetTarget(c3679515.target2)
		ge1:SetLabelObject(e0)
		Duel.RegisterEffect(ge1,0)
		local ge2=ge1:Clone()
		ge2:SetLabelObject(e0)
		Duel.RegisterEffect(ge2,1)
		--fusion summon
		_hack_fusion_check=Card.CheckFusionMaterial
		function Card.CheckFusionMaterial(card,Group_fus,Card_g,int_chkf,not_mat)
			local exg=Group.CreateGroup()
			local zone=c3679515.checkzone(card:GetControler())
			if card:IsSetCard(0x2a) and Duel.GetFlagEffect(card:GetControler(),3679515)==0 then
				exg=Duel.GetMatchingGroup(c3679515.filter0,int_chkf,LOCATION_HAND+LOCATION_MZONE+LOCATION_DECK+LOCATION_GRAVE,0,nil)
				if exg:GetCount()>0 and Duel.GetLocationCountFromEx(card:GetControler(),card:GetControler(),exg,card,zone)>0 then
					Group_fus:Merge(exg)
					if Duel.GetFlagEffect(0,3679516)~=0 then
						card:RegisterFlagEffect(3679515,RESET_EVENT+RESETS_STANDARD+RESET_CHAIN,0,1)
						local e1=Effect.CreateEffect(card)
						e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
						e1:SetCode(EVENT_SPSUMMON_SUCCESS)
						e1:SetCountLimit(1)
						e1:SetLabelObject(card)
						e1:SetOperation(c3679515.limitop)
						e1:SetReset(RESET_EVENT+RESET_CHAIN)
						Duel.RegisterEffect(e1,card:GetControler())
					end
				end
			end
			return _hack_fusion_check(card,Group_fus,Card_g,int_chkf,not_mat)
		end
		_SelectFusionMaterial=Duel.SelectFusionMaterial
		function Duel.SelectFusionMaterial(player,card,group,groupc,chkf)
			if card:GetFlagEffect(3679515)~=0 then
				local mg=_SelectFusionMaterial(player,card,group,groupc,chkf)
				local tc=mg:GetFirst()
				while tc do
					tc:RegisterFlagEffect(3679516,RESET_EVENT+RESETS_STANDARD+RESET_CHAIN,0,1)
					tc=mg:GetNext()
				end
				return mg
			end
			return _SelectFusionMaterial(player,card,group,groupc,chkf)
		end
		_SendtoGrave=Duel.SendtoGrave
		function Duel.SendtoGrave(tg,reason)
			if reason~=REASON_EFFECT+REASON_MATERIAL+REASON_FUSION or aux.GetValueType(tg)~="Group" then
				return _SendtoGrave(tg,reason)
			end
			local rg=tg:Filter(c3679515.filter1,nil)
			tg:Sub(rg)
			local ct1=_SendtoGrave(tg,reason)
			local ct2=Duel.Remove(rg,POS_FACEUP,reason)
			return ct1+ct2
		end
	end
	--local e3=Effect.CreateEffect(c)
	--e3:SetDescription(aux.Stringid(3679515,0))
	--e3:SetType(EFFECT_TYPE_FIELD)
	--e3:SetCode(EFFECT_CHAIN_MATERIAL)
	--e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	--e3:SetTargetRange(1,0)
	--e3:SetRange(LOCATION_MZONE)
	--e3:SetTarget(c3679515.chain_target)
	--e3:SetOperation(c3679515.chain_operation)
	--e3:SetValue(aux.TRUE)
	--c:RegisterEffect(e3)
end
function c3679515.matfilter(c)
	return c:IsLinkSetCard(0x2a)
end
function c3679515.filter0(c)
	return c:IsType(TYPE_MONSTER) and c:IsCanBeFusionMaterial() and c:IsAbleToRemove()
end
function c3679515.filter1(c)
	return c:GetFlagEffect(3679516)~=0
end
function c3679515.chainop(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(0,3679516,RESET_EVENT+RESET_CHAIN,0,1)
end
function c3679515.limitop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if eg:IsContains(tc) then
		Duel.RegisterFlagEffect(tc:GetControler(),3679515,RESET_PHASE+PHASE_END,0,1)
	else
		tc:ResetFlagEffect(3679515)
	end
end
function c3679515.target(e,c)
	return c:GetFlagEffect(3679515)~=0
end
function c3679515.target2(e,c)
	return c:IsSetCard(0x2a) and c:IsType(TYPE_SYNCHRO)
end
function c3679515.cfilter(c)
	return c:IsFaceup() and c:IsCode(3679515) and c:IsType(TYPE_LINK)
end
function c3679515.frcval(e,c,fp,rp,r)
	local zone=0
	local g=Duel.GetMatchingGroup(c3679515.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	for tc in aux.Next(g) do
		zone=bit.bor(zone,tc:GetLinkedZone(tp))
	end
	return bit.band(zone,0x1f)
end
function c3679515.checkzone(tp)
	local zone=0
	local g=Duel.GetMatchingGroup(c3679515.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	for tc in aux.Next(g) do
		zone=bit.bor(zone,tc:GetLinkedZone(tp))
	end
	return bit.band(zone,0x1f)
end

function c3679515.synfilter(c)
	return c:IsAttribute(ATTRIBUTE_EARTH) and ((c:IsFaceup() and c:IsLocation(LOCATION_MZONE)) or not c:IsLocation(LOCATION_MZONE)) and c:IsAbleToRemove()
end
function c3679515.syncon(e,c,smat)
	if c==nil then return true end
	if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
	if not Duel.IsPlayerAffectedByEffect(tp,3679515) then return false end
	if Duel.GetFlagEffect(tp,3679515)~=0 then return false end
	local mg=Duel.GetMatchingGroup(c3679515.synfilter,c:GetControler(),LOCATION_HAND+LOCATION_MZONE+LOCATION_DECK+LOCATION_GRAVE,0,nil)
	local zone=c3679515.checkzone(tp)
	if smat and smat:IsType(TYPE_TUNER) and c3679515.synfilter(smat) then
		return Duel.CheckTunerMaterial(c,smat,aux.Tuner(nil),aux.NonTuner(nil),1,99,mg) and Duel.GetLocationCountFromEx(tp,tp,mg,c,zone)>0 end
	return Duel.CheckSynchroMaterial(c,aux.Tuner(nil),aux.NonTuner(nil),1,99,smat,mg) and Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD,zone)>0
end
function c3679515.syntg(e,tp,eg,ep,ev,re,r,rp,chk,c,smat)
	local g=nil
	local mg=Duel.GetMatchingGroup(c3679515.synfilter,c:GetControler(),LOCATION_HAND+LOCATION_MZONE+LOCATION_DECK+LOCATION_GRAVE,0,nil)
	if smat and smat:IsType(TYPE_TUNER) and c3679515.synfilter(smat) then
		g=Duel.SelectTunerMaterial(c:GetControler(),c,smat,aux.Tuner(nil),aux.NonTuner(nil),1,99,mg)
	else
		g=Duel.SelectSynchroMaterial(c:GetControler(),c,aux.Tuner(nil),aux.NonTuner(nil),1,99,smat,mg)
	end
	if g then
		g:KeepAlive()
		e:SetLabelObject(g)
		return true
	else return false end
end
function c3679515.synop(e,tp,eg,ep,ev,re,r,rp,c,smat,mg,min,max)
	Duel.Hint(HINT_CARD,0,3679515)
	local g=e:GetLabelObject()
	c:SetMaterial(g)
	Duel.Remove(g,POS_FACEUP,REASON_MATERIAL+REASON_SYNCHRO)
	c:RegisterFlagEffect(3679515,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
	Duel.RegisterFlagEffect(tp,3679515,RESET_PHASE+PHASE_END,0,1)
	g:DeleteGroup()
end


--function c3679515.filter(c,e)
--  return c:IsType(TYPE_MONSTER) and c:IsCanBeFusionMaterial() and c:IsAbleToRemove() and not c:IsImmuneToEffect(e)
--end
--function c3679515.chain_target(e,te,tp)
--  local zone=c3679515.checkzone(tp)
--  return Duel.GetFlagEffect(tp,3679515)==0 and Duel.GetMatchingGroup(c3679515.filter,tp,LOCATION_MZONE+LOCATION_GRAVE+LOCATION_HAND+LOCATION_DECK+LOCATION_EXTRA,0,nil,te) and Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD,zone)>0
--end
--function c3679515.chain_operation(e,te,tp,tc,mat,sumtype)
--  if not sumtype then sumtype=SUMMON_TYPE_FUSION end
--  Duel.Hint(HINT_CARD,0,3679515)
--  tc:SetMaterial(mat)
--  Duel.Remove(mat,POS_FACEUP,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
--  Duel.BreakEffect()
--  tc:RegisterFlagEffect(3679515,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
--  Duel.SpecialSummon(tc,sumtype,tp,tp,false,false,POS_FACEUP)
--  Duel.RegisterFlagEffect(tp,3679515,RESET_PHASE+PHASE_END,0,1)
--end
