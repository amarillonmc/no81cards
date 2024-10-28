--狩猎游戏-无羊
function c12877025.initial_effect(c)
	c:SetSPSummonOnce(12877025)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(1166)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(c12877025.linkcon())
	e1:SetTarget(c12877025.linktg())
	e1:SetOperation(c12877025.linkop())
	e1:SetValue(SUMMON_TYPE_LINK)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetOperation(c12877025.op)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c12877025.con3)
	e3:SetOperation(c12877025.op3)
	e3:SetCountLimit(1)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(12877025)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+0x200)
	c:RegisterEffect(e4) 
end
function c12877025.linkcon()
	return	function(e,c,og,lmat)
	local f = function(c) return c:IsLinkSetCard(0x9a7b) and not c:IsLinkType(TYPE_LINK) end
				if c==nil then return true end
				if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
				local tp=c:GetControler()
				local mg=nil
				if og then
					mg=og:Filter(Auxiliary.LConditionFilter,nil,f,c,e)
				else
					mg=Auxiliary.GetLinkMaterials(tp,f,c,e)
				end
				if lmat~=nil then
					if not Auxiliary.LConditionFilter(lmat,f,c,e) then return false end
					mg:AddCard(lmat)
				end
				local fg=Duel.GetMustMaterial(tp,EFFECT_MUST_BE_LMATERIAL)
				if fg:IsExists(Auxiliary.MustMaterialCounterFilter,1,nil,mg) then return false end
				Duel.SetSelectedCard(fg)
				return mg:CheckSubGroup(Auxiliary.LCheckGoal,1,1,tp,c,nil,lmat)
			end
end
function c12877025.linktg()
	return	function(e,tp,eg,ep,ev,re,r,rp,chk,c,og,lmat)
	local f = function(c) return c:IsLinkSetCard(0x9a7b) and not c:IsLinkType(TYPE_LINK) end
				local mg=nil
				if og then
					mg=og:Filter(Auxiliary.LConditionFilter,nil,f,c,e)
				else
					mg=Auxiliary.GetLinkMaterials(tp,f,c,e)
				end
				if lmat~=nil then
					if not Auxiliary.LConditionFilter(lmat,f,c,e) then return false end
					mg:AddCard(lmat)
				end
				local fg=Duel.GetMustMaterial(tp,EFFECT_MUST_BE_LMATERIAL)
				Duel.SetSelectedCard(fg)
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_LMATERIAL)
				local cancel=Duel.IsSummonCancelable()
				local sg=mg:SelectSubGroup(tp,Auxiliary.LCheckGoal,cancel,1,1,tp,c,nil,lmat)
				if sg then
					sg:KeepAlive()
					e:SetLabelObject(sg)
					return true
				else return false end
			end
end
function c12877025.q(c)
	local ge=c:IsHasEffect(EFFECT_TO_GRAVE_REDIRECT)
	local de=c:IsHasEffect(EFFECT_TO_DECK_REDIRECT)
	local he=c:IsHasEffect(EFFECT_TO_HAND_REDIRECT)
	local le=c:IsHasEffect(EFFECT_LEAVE_FIELD_REDIRECT)
	if (ge and ge:GetValue()&LOCATION_EXTRA==0)
		or (he and he:GetValue()&LOCATION_EXTRA==0) 
		or (de and de:GetValue()&LOCATION_EXTRA==0) 
		or (le and le:GetValue()&LOCATION_EXTRA==0)
	then return end
	return c:IsType(TYPE_PENDULUM) and not c:IsForbidden()
end
function c12877025.linkop()
	return	function(e,tp,eg,ep,ev,re,r,rp,c,og,lmat)
				local g=e:GetLabelObject()
				Auxiliary.LExtraMaterialCount(g,c,tp)
				local pg=g:Filter(c12877025.q,nil)
				if #pg>0 and (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) and Duel.SelectEffectYesNo(tp,c,aux.Stringid(12877025,0)) then
				Duel.Hint(3,tp,HINTMSG_TOFIELD)
				local sg=pg:Select(tp,1,1,nil)
				Duel.MoveToField(sg:GetFirst(),tp,tp,LOCATION_PZONE,POS_FACEUP,true)
				g:RemoveCard(sg:GetFirst())
				end
				c:SetMaterial(g)
				Duel.SendtoGrave(g,REASON_MATERIAL+REASON_LINK)
				g:DeleteGroup()
			end
end
function c12877025.op(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(12877025,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
end
function c12877025.con3(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(12877025)~=0 and Duel.GetTurnPlayer()==tp
end
function c12877025.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local op=aux.SelectFromOptions(tp,{true,aux.Stringid(12877025,1),0},{Duel.IsAbleToEnterBP(),aux.Stringid(12877025,2),1})
	if op==0 then
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_LEAVE_FIELD)
		e2:SetCondition(c12877025.leavecon)
		e2:SetOperation(c12877025.leaveop)
		e2:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e2,tp)
	elseif op==1 then	
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_FIELD)
		e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e3:SetCode(EFFECT_CANNOT_ACTIVATE)
		e3:SetTargetRange(0,1)
		e3:SetCondition(c12877025.actcon)
		e3:SetValue(1)
		e3:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e3,tp)
	end
end
function c12877025.leavecon(e)
	local ph=Duel.GetCurrentPhase()
	return ph== PHASE_MAIN1 or ph==PHASE_MAIN2
end
function c12877025.w(c,tp)
	return c:IsPreviousControler(1-tp) and not (c:IsLocation(LOCATION_DECK+LOCATION_EXTRA+LOCATION_REMOVED) and c:IsFacedown())
end
function c12877025.leaveop(e,tp,eg,ep,ev,re,r,rp)
	local lg=eg:Filter(c12877025.w,nil,tp)
	if #lg<=0 then return end
	for tc in aux.Next(lg) do
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EFFECT_CANNOT_TRIGGER)	
	e1:SetReset(RESET_EVENT+0x17a0000)
	tc:RegisterEffect(e1,true)
	end
end
function c12877025.actcon(e)
	local ph=Duel.GetCurrentPhase()
	return ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE
end