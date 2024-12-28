--秘计螺旋 渎神
local s,id,o=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	--material
	aux.AddFusionProcFunRep(c,s.mfilter,4,true)
	--special summon rule
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e0:SetCondition(s.spcon)
	e0:SetOperation(s.spop)
	c:RegisterEffect(e0)
	--Equip Fadown
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_SINGLE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,id+1)
	e1:SetTarget(s.eqtg)
	e1:SetOperation(s.eqop)
	c:RegisterEffect(e1)
	--add effect
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(EVENT_EQUIP)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(s.efcon)
	e2:SetOperation(s.efop)
	c:RegisterEffect(e2)
	local e21=e2:Clone()
	e21:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e21:SetCode(EVENT_CUSTOM+65131100)
	c:RegisterEffect(e21)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetCode(id)
	e3:SetRange(LOCATION_MZONE)
	c:RegisterEffect(e3)
	local _Equip=Duel.Equip
	function Duel.Equip(p,card1,card2,bool,...)
		if bool==false and card2:GetOriginalCode()==id and card1:IsType(TYPE_SPELL) and not card1:IsType(TYPE_EQUIP) then
			local ctype=Duel.ReadCard(card1,CARDDATA_TYPE)
			local og=Duel.GetFieldGroup(0,LOCATION_EXTRA,LOCATION_EXTRA):Filter(aux.TRUE,card1):GetFirst()
			if og then Duel.Overlay(og,card1) end
			card1:SetCardData(CARDDATA_TYPE,TYPE_EQUIP+TYPE_SPELL)
			local count=_Equip(p,card1,card2,bool,...)
			card1:SetCardData(CARDDATA_TYPE,ctype)
			return count
		else
			return _Equip(p,card1,card2,bool,...)
		end
		
	end
end

function s.mfilter(c,fc,sub,mg,sg)
	return c:IsFusionSetCard(0x836)
end
function s.matfilter(c,sc)
	return c:IsFusionSetCard(0x836) and c:IsAbleToGraveAsCost() and c:IsCanBeFusionMaterial(sc,SUMMON_TYPE_SPECIAL)
end
function s.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local st1=Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD+LOCATION_HAND,0)
	local st2=Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD)
	local st=0  
	local g1=Duel.GetMatchingGroup(s.matfilter,tp,LOCATION_ONFIELD,0,nil,c)
	if st2>st1 then
		local g2=Duel.GetMatchingGroup(s.matfilter,tp,LOCATION_EXTRA,0,c,c)
		st=math.min(st2-st1,g2:GetCount())
	end
	return g1:GetCount()+st>=4
end
function s.fselect(g,tp,sc,st)
	return Duel.GetLocationCountFromEx(tp,tp,g,sc)>0 and g:FilterCount(Card.IsLocation,nil,LOCATION_EXTRA)<=st
end
function s.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g1=Duel.GetMatchingGroup(s.matfilter,tp,LOCATION_ONFIELD,0,c,c) 
	local st1=Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD+LOCATION_HAND,0)
	local st2=Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD)
	local st=0
	if st2>st1 then
		local g2=Duel.GetMatchingGroup(s.matfilter,tp,LOCATION_EXTRA,0,c,c)
		g1=g1:__bxor(g2)
		st=math.min(st2-st1,g2:GetCount())
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local sg=g1:SelectSubGroup(tp,s.fselect,false,4,4,tp,c,st)  
	c:SetMaterial(sg)
	Duel.SendtoGrave(sg,REASON_COST)
end
function s.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,3,tp,LOCATION_DECK)
	Duel.SetChainLimit(aux.FALSE)
end
function s.IsSequence(c,seq)
	return c:GetSequence()==seq
end
function s.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		for i=1,3 do
			local g=Duel.GetFieldGroup(tp,LOCATION_DECK,0)
			local tc=g:Filter(s.IsSequence,nil,0):GetFirst()
			if tc and tc:IsFacedown() and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.IsPlayerCanSSet(tp,tc) then
				Duel.DisableShuffleCheck()
				if tc:IsForbidden() then
					Duel.SendtoGrave(tc,REASON_RULE)
					return
				end
				
				if not Duel.Equip(tp,tc,c,false) then return end
				
				--equip limit
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e1:SetCode(EFFECT_EQUIP_LIMIT)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				e1:SetValue(s.eqlimit)
				tc:RegisterEffect(e1)
				tc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,0,1)
				--atk up
				local e2=Effect.CreateEffect(c)
				e2:SetType(EFFECT_TYPE_EQUIP)
				e2:SetCode(EFFECT_UPDATE_ATTACK)
				e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
				e2:SetValue(500)
				e2:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e2)
				Duel.RaiseEvent(tc,EVENT_SSET,e,REASON_EFFECT,tp,tp,0)
				--Duel.AdjustAll()
			else
				break
			end		 
		end	 
	end
	local e0=Effect.CreateEffect(c) 
	e0:SetDescription(aux.Stringid(id,0))
	e0:SetType(EFFECT_TYPE_FIELD) 
	e0:SetCode(id)
	e0:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
	e0:SetReset(RESET_PHASE+PHASE_END,2)
	e0:SetTargetRange(1,0) 
	Duel.RegisterEffect(e0,tp)
	local e01=Effect.CreateEffect(e:GetHandler())
	e01:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e01:SetCode(EVENT_PHASE+PHASE_END)
	e01:SetCountLimit(1)
	e01:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e01:SetLabel(Duel.GetTurnCount())
	e01:SetCondition(s.deadcon)
	e01:SetOperation(s.deadop)
	e01:SetReset(RESET_PHASE+PHASE_END,2)
	Duel.RegisterEffect(e01,tp)
end
function s.eqlimit(e,c)
	return e:GetOwner()==c
end
function s.deadcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnCount()~=e:GetLabel()
end
function s.deadop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,id)
	Duel.SetLP(tp,0)
end
function s.effilter(c,ec)
	return c:GetEquipTarget()==ec and c:GetOriginalType()&(TYPE_SPELL+TYPE_TRAP)>0 and c:GetControler()==ec:GetControler() and c:IsFacedown()
end
function s.efcon(e,tp,eg,ep,ev,re,r,rp)
	local dg=eg:Filter(s.effilter,nil,e:GetHandler())
	return dg:GetCount()>0
end
function s.efop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local dg=eg:Filter(s.effilter,nil,e:GetHandler())
	for tc in aux.Next(dg) do
		s.addeffect(tc)
	end
end
function s.addeffect(c) 
	local efft={c:GetActivateEffect()}
	for i,v in pairs(efft) do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_QUICK_O)
		e1:SetDescription(aux.Stringid(id,1))
		--e1:SetCode(EVENT_FREE_CHAIN)
		e1:SetRange(LOCATION_SZONE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetCode(v:GetCode())
		e1:SetDescription(v:GetDescription())
		e1:SetCategory(v:GetCategory())
		e1:SetProperty(v:GetProperty()|EFFECT_FLAG_SET_AVAILABLE)
		e1:SetCost(s.cost(v))
		e1:SetCondition(s.condition(v))
		e1:SetTarget(s.target(v))
		e1:SetOperation(s.operation(v))
		c:RegisterEffect(e1,true)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e2:SetLabelObject(e1)
		e2:SetCode(EVENT_CUSTOM+65131100)
		e2:SetOperation(s.reop)
		--c:RegisterEffect(e2,true)
	end
end
function s.reop(e,tp,eg,ep,ev,re,r,rp)
	e:GetLabelObject():Reset()
	e:Reset()
end
function s.cost(ae)
	return function (e,tp,eg,ep,ev,re,r,rp,chk)
		local c=e:GetHandler()
		local fcost=ae:GetCost()
		if chk==0 then return ae:CheckCountLimit(tp) and (not fcost or fcost(e,tp,eg,ep,ev,re,r,rp,chk)) end
		ae:UseCountLimit(tp,1)
		Duel.ChangePosition(c,POS_FACEUP)
		--c:CancelToGrave(false)
		--e:SetType(EFFECT_TYPE_ACTIVATE)
		if fcost then
			fcost(e,tp,eg,ep,ev,re,r,rp,chk)
		end
	end
end
function s.condition(ae)
	return function (e,tp,eg,ep,ev,re,r,rp)
		local c=e:GetHandler()
		local tc=c:GetEquipTarget()
		local fcon=ae:GetCondition()
		return tc and tc:IsHasEffect(id) and c:IsFacedown() and (not fcon or fcon(e,tp,eg,ep,ev,re,r,rp))
	end
end
function s.target(ae)   
	return function (e,tp,eg,ep,ev,re,r,rp,chk,chkc)		
		local c=e:GetHandler()
		local ftg=ae:GetTarget()
		if chk==0 then return not ftg or ftg(e,tp,eg,ep,ev,re,r,rp,chk) end
		--Duel.MoveToField(e:GetHandler(),tp,tp,LOCATION_FZONE,POS_FACEUP,true)
		
		if ftg then
			ftg(e,tp,eg,ep,ev,re,r,rp,chk)
		end
	end
end
function s.operation(ae)
	return function (e,tp,eg,ep,ev,re,r,rp)
		local c=e:GetHandler()  
		--e:GetHandler():ReleaseRelation(e:GetHandler():GetEquipTarget())
		local fop=ae:GetOperation()
		if fop then
			fop(e,tp,eg,ep,ev,re,r,rp)
		end
	end
end