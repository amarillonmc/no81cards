--Risucchia Confusione - 996ICU
--Scripted by: XGlitchy30

local s,id=GetID()
s.unique_label = 0
xpcall(function() require("expansions/script/glitchylib_vsnemo") end,function() require("script/glitchylib_vsnemo") end)

function s.initial_effect(c)
	s.unique_label = s.unique_label + 1
	--ss proc
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(id,0))
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e0:SetCondition(s.hspcon)
	e0:SetTarget(s.hsptg)
	e0:SetOperation(s.hspop)
	c:RegisterEffect(e0)
	--cannot material
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
	e1:SetValue(s.matlimit)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	c:RegisterEffect(e3)
	local e4=e1:Clone()
	e4:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	c:RegisterEffect(e4)
	--tribute protection
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EFFECT_UNRELEASABLE_SUM)
	e5:SetValue(1)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EFFECT_UNRELEASABLE_NONSUM)
	c:RegisterEffect(e6)
	--hand traps
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD)
	e7:SetCode(EFFECT_TRAP_ACT_IN_NTPHAND)
	e7:SetRange(LOCATION_MZONE)
	e7:SetTarget(s.trapfilter)
	e7:SetTargetRange(LOCATION_HAND,0)
	c:RegisterEffect(e7)
	--apply effects
	local e8=Effect.CreateEffect(c)
	e8:SetDescription(aux.Stringid(id,1))
	e8:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e8:SetCode(EVENT_SUMMON_SUCCESS)
	e8:SetTarget(s.target)
	e8:SetOperation(s.operation(s.unique_label))
	c:RegisterEffect(e8)
	local e8x=e8:Clone()
	e8x:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e8x)
	local e8y=e8:Clone()
	e8y:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e8y)
	if not s.global_check then
		s.global_check=true
		s.resolution_tracker={}
		s.resolution_count=0
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_CHAIN_SOLVED)
		e2:SetOperation(s.regop)
		Duel.RegisterEffect(e2,0)
	end
end
function s.regop(e,tp,eg,ep,ev,re,r,rp)
	if not re:GetHandler():IsCode(table.unpack(ARCHE_UTTER_CONFUSION)) or not re:IsHasType(EFFECT_TYPE_ACTIVATE) then return end
	local cid=re:GetHandler():GetCode()
	if not s.resolution_tracker[cid] then
		s.resolution_tracker[cid]=true
		s.resolution_count = s.resolution_count + 1
	end
end

function s.spfilter(c)
	return c:IsCode(table.unpack(ARCHE_UTTER_CONFUSION)) and c:IsAbleToRemoveAsCost()
end
function s.mzonechk_g(g,tp)
	return g:IsExists(s.mzonechk,1,nil,tp)
end
function s.mzonechk(g,tp)
	return Duel.GetMZoneCount(tp,c)>0
end
function s.hspcon(e,c)
	if c==nil then return true end
	local eff={c:IsHasEffect(EFFECT_NECRO_VALLEY)}
	for _,ce in ipairs(eff) do
		if ce and aux.GetValueType(ce)=="Effect" and ce.GetLabel then
			local op=ce:GetOperation()
			if not op or op(e,c) then return false end
		end
	end
	local tp=c:GetControler()
	local rg=Duel.GetMatchingGroup(s.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,c)
	return rg:CheckSubGroup(s.mzonechk_g,2,2,tp)
end
function s.hsptg(e,tp,eg,ep,ev,re,r,rp,c)
	local rg=Duel.GetMatchingGroup(s.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,c)
	local g=rg:SelectSubGroup(tp,s.mzonechk_g,true,2,2,tp)
	if #g<2 then return false end
	g:KeepAlive()
	e:SetLabelObject(g)
	return true
end
function s.hspop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	if not g then return end
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	g:DeleteGroup()
end

function s.matlimit(e,c)
	if not c then return false end
	return c:IsLocation(LOCATION_EXTRA)
end

function s.trapfilter(e,c)
	return c:GetType()==0x4 and c:IsCode(table.unpack(ARCHE_UTTER_CONFUSION))
end

function s.df(c,e)
	return c:IsOnField() or c:IsDestructable(e)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local ct=s.resolution_count
	if ct>=4 then
		Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,0)
	end
	if ct>=7 then
		local g=Duel.GetMatchingGroup(s.df,tp,0,LOCATION_ONFIELD+LOCATION_HAND+LOCATION_DECK+LOCATION_EXTRA,nil,e)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,#g,0,0)
	end
end
function s.operation(lab)
	return	function(e,tp,eg,ep,ev,re,r,rp)
				local c=e:GetHandler()
				local ct=s.resolution_count
				if ct>=2 then
					local e1=Effect.CreateEffect(c)
					e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
					e1:SetCode(EVENT_ADJUST)
					e1:SetLabel(e:GetFieldID())
					e1:SetOperation(s.chkop(lab))
					Duel.RegisterEffect(e1,tp)
					ct=s.resolution_count
					Duel.RegisterFlagEffect(1-tp,id,0,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(id,2))
					Duel.BreakEffect()
				end
				if ct>=4 then
					Duel.Damage(1-tp,Duel.GetLP(1-tp),REASON_EFFECT)
					ct=s.resolution_count
					Duel.BreakEffect()
				end
				if ct>=7 then
					local g=Duel.GetMatchingGroup(s.df,tp,0,LOCATION_ONFIELD+LOCATION_HAND+LOCATION_DECK+LOCATION_EXTRA,nil,e)
					if #g>0 then
						Duel.Destroy(g,REASON_EFFECT)
					end
				end
			end
end

function s.notflag(c,lab,fid)
	return c:IsFaceup() and (c:GetFlagEffect(id+lab*100)==0 or c:GetFlagEffectLabel(id+lab*100)~=fid)
end
function s.chkop(lab)
	return	function(e,tp,eg,ep,ev,re,r,rp)
				local c=e:GetHandler()
				local g=Duel.GetMatchingGroup(s.notflag,tp,0,LOCATION_MZONE,nil,lab,e:GetLabel())
				if #g<=0 then return end
				local dg=Group.CreateGroup()
				for tc in aux.Next(g) do
					local preatk,predef=tc:GetAttack(),tc:GetDefense()
					local e1=Effect.CreateEffect(c)
					e1:SetType(EFFECT_TYPE_SINGLE)
					e1:SetCode(EFFECT_UPDATE_ATTACK)
					e1:SetValue(-2000)
					e1:SetReset(RESET_EVENT+RESETS_STANDARD)
					tc:RegisterEffect(e1)
					local e2=e1:Clone()
					e2:SetCode(EFFECT_UPDATE_DEFENSE)
					tc:RegisterEffect(e2)
					if tc:GetFlagEffect(id+lab*100)==0 then
						tc:RegisterFlagEffect(id+lab*100,RESET_EVENT+RESETS_STANDARD,0,1)
					end
					tc:SetFlagEffectLabel(id+lab*100,e:GetLabel())
					if preatk~=0 and not tc:IsImmuneToEffect(e1) and tc:GetAttack()==0 and predef~=0 and not tc:IsImmuneToEffect(e2) and tc:GetDefense()==0 then
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