--键★断片 - 缭绕琴美的弦理论 || Frammenti K.E.Y - Kotomi, Teoria delle Stringhe
--Scripted by: XGlitchy30

xpcall(function() require("expansions/script/glitchylib_vsnemo") end,function() require("script/glitchylib_vsnemo") end)

local s,id=GetID()
s.unique_label = 0
function s.initial_effect(c)
	s.unique_label = s.unique_label + 1
	c:SetCounterLimit(0x1460,1)
	--equip
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetTarget(s.eqtg)
	e1:SetOperation(s.eqop)
	c:RegisterEffect(e1)
	local e1x=e1:Clone()
	e1x:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e1x)
	local e1y=e1:Clone()
	e1y:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e1y)
	--equip effects
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetCondition(s.eqcon)
	e2:SetTarget(s.stattg(s.unique_label))
	e2:SetValue(s.eqval)
	c:RegisterEffect(e2)
	local e2x=Effect.CreateEffect(c)
	e2x:SetDescription(aux.Stringid(id,1))
	e2x:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2x:SetCode(EVENT_ADJUST)
	e2x:SetRange(LOCATION_SZONE)
	e2x:SetLabelObject(e2)
	e2x:SetCondition(s.eqcon)
	e2x:SetOperation(s.chkop(s.unique_label))
	c:RegisterEffect(e2x)
	--light orb
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,2))
	e3:SetCategory(CATEGORY_COUNTER)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetRange(LOCATION_ONFIELD)
	e3:SetCode(EVENT_CUSTOM+id)
	e3:SetCondition(s.ctcon)
	e3:SetTarget(s.cttg)
	e3:SetOperation(s.ctop)
	c:RegisterEffect(e3)
	if not s.global_check then
		s.global_check=true
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_TO_HAND)
		e1:SetOperation(s.regop)
		Duel.RegisterEffect(e1,0)
	end
end
function s.regfilter(c,p)
	return c:IsPreviousLocation(LOCATION_ONFIELD+LOCATION_GRAVE) and c:IsLocation(LOCATION_HAND) and c:IsPreviousControler(p) and c:IsControler(p)
end
function s.regop(e,tp,eg,ep,ev,re,r,rp)
	for p=tp,1-tp,1-2*tp do
		local g=eg:Filter(s.regfilter,nil,p)
		if #g>0 then
			local ct=Duel.GetFlagEffect(p,id)>0 and Duel.GetFlagEffectLabel(p,id) or 0
			if ct==0 then
				Duel.RegisterFlagEffect(p,id,RESET_PHASE+PHASE_END,0,1,0)
			end
			Duel.SetFlagEffectLabel(p,id,Duel.GetFlagEffectLabel(p,id)+#g)
			if ct<3 and Duel.GetFlagEffectLabel(p,id)>=3 then
				Duel.RaiseEvent(eg,EVENT_CUSTOM+id,re,r,rp,p,ev)
			end
		end
	end
end

function s.eqfilter(c,tp)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x460) and c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsRace(RACE_SPELLCASTER+RACE_WARRIOR)
		and c:CheckUniqueOnField(tp) and not c:IsForbidden()
end
function s.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_DECK)
end
function s.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFacedown() or not c:IsRelateToChain(0) or Duel.GetLocationCount(tp,LOCATION_SZONE)<1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local tc=Duel.SelectMatchingCard(tp,s.eqfilter,tp,LOCATION_DECK,0,1,1,nil,tp):GetFirst()
	if tc then
		if not Duel.Equip(tp,tc,c) then return end
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_COPY_INHERIT+EFFECT_FLAG_OWNER_RELATE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetValue(s.eqlimit)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
	end
end
function s.eqlimit(e,c)
	return e:GetOwner()==c
end

function s.eqcon(e)
	local ec=e:GetHandler():GetEquipTarget()
	return ec and ec:IsSetCard(0x460) and ec:HasDefense() and ec:GetDefense()>0
end
function s.stattg(lab)
	return	function(e,tc)
				return tc:GetFlagEffect(id+lab*100)~=0 and tc:GetFlagEffectLabel(id+lab*100)==e:GetLabel()
			end
end
function s.eqval(e,c)
	return -e:GetHandler():GetEquipTarget():GetDefense()
end

function s.notflag(c,lab,fid)
	return c:IsFaceup() and (c:GetFlagEffect(id+lab*100)==0 or c:GetFlagEffectLabel(id+lab*100)~=fid)
end
function s.chkop(lab)
	return	function(e,tp,eg,ep,ev,re,r,rp)
				local c=e:GetHandler()
				local fid=c:GetFieldID()
				if e:GetLabelObject():GetLabel()~=fid then
					e:GetLabelObject():SetLabel(fid)
				end
				local g=Duel.GetMatchingGroup(s.notflag,tp,0,LOCATION_MZONE,nil,lab,fid)
				if #g<=0 then return end
				local dg=Group.CreateGroup()
				for tc in aux.Next(g) do
					local preatk,predef=tc:GetAttack(),tc:GetDefense()
					if tc:GetFlagEffect(id+lab*100)==0 then
						tc:RegisterFlagEffect(id+lab*100,RESET_EVENT+RESETS_STANDARD,0,1)
					end
					tc:SetFlagEffectLabel(id+lab*100,fid)
					if preatk~=0 and not tc:IsImmuneToEffect(e:GetLabelObject()) and tc:GetAttack()==0 then
						dg:AddCard(tc)
					end
				end
				if #dg>0 then
					for tc in aux.Next(dg) do
						Duel.Negate(tc,e)
					end
					Duel.Readjust()
				end
				dg:DeleteGroup()
			end
end

function s.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp
end
function s.cttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local c=e:GetHandler()
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,c,1,0,0x1460)
end
function s.ctop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() and c:IsCanAddCounter(0x1460,1,false,c:GetLocation()) then
		c:AddCounter(0x1460,1)
	end
end