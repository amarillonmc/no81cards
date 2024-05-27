if not require and dofile then function require(str) return dofile(str..".lua") end end
if not pcall(function() require("expansions/script/c53702500") end) then require("script/c53702500") end
local s,id,o=GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.acttg)
	e1:SetOperation(s.actop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(s.thtg)
	e2:SetOperation(s.thop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,2))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCondition(s.descon)
	e3:SetTarget(s.destg)
	e3:SetOperation(s.desop)
	--c:RegisterEffect(e3)
	if not s.global_check then
		s.global_check=true
		local ge1=Effect.GlobalEffect()
		ge1:SetType(EFFECT_TYPE_FIELD)
		ge1:SetCode(EFFECT_ACTIVATE_COST)
		ge1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		ge1:SetTargetRange(1,1)
		ge1:SetTarget(s.actarget)
		ge1:SetOperation(s.acop)
		Duel.RegisterEffect(ge1,0)
		local f1=Card.GetCode
		Card.GetCode=function(sc)
			local code={f1(sc)}
			if sc:GetFlagEffect(id)>0 then for k,v in pairs(code) do if v==id+6 then table.remove(code,k) table.insert(code,sc:GetFlagEffectLabel(id)) end end end
			return table.unpack(code)
		end
		local f2=Card.GetOriginalCodeRule
		Card.GetOriginalCodeRule=function(sc)
			local code={f2(sc)}
			if sc:GetFlagEffect(id)>0 then for k,v in pairs(code) do if v==id+6 then table.remove(code,k) table.insert(code,sc:GetFlagEffectLabel(id)) end end end
			return table.unpack(code)
		end
		local f3=Card.GetOriginalCode
		Card.GetOriginalCode=function(sc)
			return sc:GetFlagEffectLabel(id) or f3(sc)
		end
		local f4=Card.IsCode
		Card.IsCode=function(sc,...)
			local code={...}
			local res=f4(sc,...)
			if sc:GetFlagEffect(id)>0 and SNNM.IsInTable(sc:GetFlagEffectLabel(id),code) then res=true end
			return res
		end
		local f5=Card.IsOriginalCodeRule
		Card.IsCode=function(sc,...)
			local code={...}
			local res=f5(sc,...)
			if sc:GetFlagEffect(id)>0 and SNNM.IsInTable(sc:GetFlagEffectLabel(id),code) then res=true end
			return res
		end
		local f6=Duel.ChangePosition
		Duel.ChangePosition=function(sc,au,...)
			local g=Group.__add(sc,sc)
			if au&POS_FACEUP~=0 then g:ForEach(s.turn) end
			return f6(sc,au,...)
		end
		local f7=Duel.Overlay
		Duel.Overlay=function(sc,ocard)
			local g=Group.__add(ocard,ocard)
			g:ForEach(s.turn)
			return f7(sc,ocard)
		end
		local f8=Duel.ConfirmCards
		Duel.ConfirmCards=function(p,tg,bool)
			local g=Group.__add(tg,tg):Filter(function(c)return c:GetFlagEffect(id)>0 end,nil)
			for tc in aux.Next(g) do tc:SetCardData(CARDDATA_CODE,tc:GetFlagEffectLabel(id)) end
			f8(p,tg,bool)
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,0))
			g:Select(p,0,#g,nil)
			g:ForEach(Card.SetCardData,CARDDATA_CODE,id+6)
		end
	end
end
s.checks=aux.CreateChecks(Card.IsOriginalCodeRule,{id+1,id+2,id+3,id+4,id+5})function s.actarget(e,te,tp)
	e:SetLabelObject(te)
	return true
end
function s.acop(e,tp,eg,ep,ev,re,r,rp)
	s.turn(e:GetLabelObject():GetHandler())
end
function s.desfilter(c)
	return c:GetSequence()<5
end
function s.acttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(s.desfilter,tp,LOCATION_SZONE,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function s.actop(e,tp,eg,ep,ev,re,r,rp)
	local chk
	local g=Duel.GetMatchingGroup(s.desfilter,tp,LOCATION_SZONE,0,nil)
	if g:GetCount()>0 then chk=true Duel.Destroy(g,REASON_EFFECT) end
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<5 then return end
	local g=Group.__add(Duel.GetMatchingGroup(Card.IsFaceupEx,tp,0xff,0,nil),Duel.GetOverlayGroup(tp,1,0))
	if not g:CheckSubGroupEach(s.checks) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local sg=g:SelectSubGroupEach(tp,s.checks)
	if chk then Duel.BreakEffect() end
	if Duel.SSet(tp,sg)==0 then return end
	local og=Duel.GetOperatedGroup():Filter(aux.AND(Card.IsFacedown,Card.IsLocation),nil,LOCATION_SZONE)
	s.hide(e,og)
	Duel.ShuffleSetCard(og)
end
function s.hide(e,og)
	for tc in aux.Next(og) do
		local code=tc:GetOriginalCode()
		tc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,0,1,code)
		tc:SetCardData(CARDDATA_CODE,id+6)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_LEAVE_FIELD_P)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SET_AVAILABLE)
		e1:SetOperation(s.retop)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1,true)
		local e2=e1:Clone()
		e2:SetCode(EVENT_MOVE)
		e2:SetCondition(s.retcon)
		tc:RegisterEffect(e2,true)
	end
end
function s.retcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_SZONE) and not c:IsLocation(LOCATION_SZONE)
end
function s.retop(e,tp,eg,ep,ev,re,r,rp)
	s.turn(e:GetHandler())
end
function s.turn(c)
	if c:GetFlagEffect(id)~=0 then
		local code=c:GetFlagEffectLabel(id)
		c:ResetFlagEffect(id)
		c:SetCardData(CARDDATA_CODE,code)
	end
end
function s.thfilter(c)
	return c:GetSequence()<5 and c:IsAbleToHand()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(s.thfilter,tp,LOCATION_SZONE,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,g:GetCount(),0,0)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(s.thfilter,tp,LOCATION_SZONE,0,nil)
	if #g==0 or Duel.SendtoHand(g,nil,REASON_EFFECT)==0 then return end
	local sg=Duel.GetOperatedGroup():Filter(Card.IsLocation,nil,LOCATION_HAND):Filter(Card.IsSSetable,nil)
	if #sg==0 or Duel.GetLocationCount(tp,LOCATION_SZONE)<#sg then return end
	if Duel.SSet(tp,sg)==0 then return end
	local og=Duel.GetOperatedGroup():Filter(aux.AND(Card.IsFacedown,Card.IsLocation),nil,LOCATION_SZONE)
	s.hide(e,og)
	Duel.ShuffleSetCard(og)
end
function s.descfilter(c,tp)
	return c:GetPreviousTypeOnField()&0x6~=0 and c:IsPreviousControler(tp)
end
function s.descon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.descfilter,1,nil,tp) and (not re or re:GetOwner()~=e:GetHandler())
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return true end
	local sg=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_ONFIELD,0,nil,0x6)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_ONFIELD,0,nil,0x6)
	if #sg>0 then Duel.Destroy(sg,REASON_EFFECT) end
end
