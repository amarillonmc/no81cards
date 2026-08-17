-- 领域展开！无量空处！
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,65823000)
	--放置
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAIN_SOLVING)
	e3:SetRange(LOCATION_HAND)
	e3:SetCondition(s.recon)
	e3:SetOperation(s.reop)
	c:RegisterEffect(e3)
	--disable
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAIN_SOLVING)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCondition(s.discon)
	e3:SetOperation(s.disop)
	c:RegisterEffect(e3)
	if not s.global_check then
      s.global_check=true
      local ge1=Effect.CreateEffect(c)
      ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
      ge1:SetCode(EVENT_ADJUST)
			ge1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
      ge1:SetOperation(s.checkop6)
      Duel.RegisterEffect(ge1,0)
  end
end

function s.checkop6(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	if ph>PHASE_MAIN1 and ph<PHASE_MAIN2 then ph=PHASE_BATTLE end
	for p=0,1 do
		local tc=Duel.GetFieldCard(p,LOCATION_FZONE,0)
		if tc and s.locfilter(tc,p) then
			if tc:GetFlagEffect(65823025)==0 then 
				if tc:GetFlagEffect(65823026)==0 then
					tc:RegisterFlagEffect(65823026,RESET_EVENT+RESETS_STANDARD,0,1)
				else
					Duel.SendtoGrave(tc,REASON_EFFECT)
				end
				tc:RegisterFlagEffect(65823025,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+ph,0,1)
			end
		end
	end
end
function s.locfilter(c)
	return c:IsOriginalCodeRule(id) and c:IsFaceup()
end

function s.tnop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.SendtoGrave(c,REASON_EFFECT)
end

function s.recon(e)
    local tp=e:GetHandlerPlayer()
    return Duel.IsExistingMatchingCard(s.gojofilter1,tp,LOCATION_MZONE,0,1,nil)
end
function s.gojofilter1(c)
    return c:IsFaceup() and c:IsCode(65823000)
end
function s.reop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if  Duel.GetFlagEffect(tp,id)==0 and not c:IsForbidden() and c:CheckUniqueOnField(tp) and c:IsLocation(LOCATION_HAND) and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
		Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,0,1)
	  local fc=Duel.GetFieldCard(tp,LOCATION_FZONE,0)
		if fc then
			Duel.Destroy(fc,REASON_RULE)
		end
		Duel.MoveToField(c,tp,tp,LOCATION_FZONE,POS_FACEUP,true) 
		Duel.Hint(24,0,aux.Stringid(id,1))
	end
end

function s.discon(e,tp,eg,ep,ev,re,r,rp)
	local p,loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_CONTROLER,CHAININFO_TRIGGERING_LOCATION)
	return re:IsActiveType(TYPE_MONSTER) and loc==LOCATION_MZONE
end
function s.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,id)
  Duel.ChangeChainOperation(ev,aux.NULL)
end