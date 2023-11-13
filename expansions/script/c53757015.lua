if not require and dofile then function require(str) return dofile(str..".lua") end end
if not pcall(function() require("expansions/script/c53702500") end) then require("script/c53702500") end
local s,id,o=GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)return Duel.GetFlagEffect(0,id)==0 end)
	e1:SetOperation(s.effop)
	c:RegisterEffect(e1)
	if not Dimen_Diffusion_Check then
		Dimen_Diffusion_Check=true
		DimenCard_Table={}
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		ge1:SetCountLimit(1,id+EFFECT_COUNT_CODE_DUEL)
		ge1:SetOperation(s.op)
		Duel.RegisterEffect(ge1,0)
		Dimen_IsSetCard=Card.IsSetCard
		Card.IsSetCard=function(tc,...)
			if (Duel.GetFlagEffect(0,id)>0 and SNNM.IsInTable(tc:GetCode(),DimenCard_Table)) or tc:GetOriginalCode()==id then return Dimen_IsSetCard(tc,...) or Dimen_IsSetCard(tc,0x6531,0x6532,0x9532,0xa532,0xc533) end
			return Dimen_IsSetCard(tc,...)
		end
		Dimen_IsFusionSetCard=Card.IsFusionSetCard
		Card.IsFusionSetCard=function(tc,...)
			if (Duel.GetFlagEffect(0,id)>0 and SNNM.IsInTable(tc:GetCode(),DimenCard_Table)) or tc:GetOriginalCode()==id then return Dimen_IsFusionSetCard(tc,...) or Dimen_IsFusionSetCard(tc,0x6531,0x6532,0x9532,0xa532,0xc533) end
			return Dimen_IsFusionSetCard(tc,...)
		end
		Dimen_IsLinkSetCard=Card.IsLinkSetCard
		Card.IsLinkSetCard=function(tc,...)
			if (Duel.GetFlagEffect(0,id)>0 and SNNM.IsInTable(tc:GetCode(),DimenCard_Table)) or tc:GetOriginalCode()==id then return Dimen_IsLinkSetCard(tc,...) or Dimen_IsLinkSetCard(tc,0x6531,0x6532,0x9532,0xa532,0xc533) end
			return Dimen_IsLinkSetCard(tc,...)
		end
		Dimen_IsPreviousSetCard=Card.IsPreviousSetCard
		Card.IsPreviousSetCard=function(tc,...)
			if (Duel.GetFlagEffect(0,id)>0 and SNNM.IsInTable(tc:GetCode(),DimenCard_Table)) or tc:GetOriginalCode()==id then return Dimen_IsPreviousSetCard(tc,...) or Dimen_IsPreviousSetCard(tc,0x6531,0x6532,0x9532,0xa532,0xc533) end
			return Dimen_IsPreviousSetCard(tc,...)
		end
		Dimen_IsOriginalSetCard=Card.IsOriginalSetCard
		Card.IsOriginalSetCard=function(tc,...)
			if tc:GetOriginalCode()==id then return Dimen_IsOriginalSetCard(tc,...) or Dimen_IsOriginalSetCard(tc,0x6531,0x6532,0x9532,0xa532,0xc533) end
			return Dimen_IsOriginalSetCard(tc,...)
		end
		Dimen_AnnounceCard=Duel.AnnounceCard
		Duel.AnnounceCard=function(tp,a1,...)
			local t={id,OPCODE_ISCODE,OPCODE_NOT}
			if a1 then
				t={a1,...}
				if not SNNM.IsInTable(OPCODE_AND,t) and not SNNM.IsInTable(OPCODE_OR,t) and SNNM.IsInTable(OPCODE_ISCODE,t) and SNNM.IsInTable(id,t) and not SNNM.IsInTable(OPCODE_NOT,t) then return 0 end
				table.insert(t,id)
				table.insert(t,OPCODE_ISCODE)
				table.insert(t,OPCODE_NOT)
				table.insert(t,OPCODE_AND)
			end
			return Dimen_AnnounceCard(tp,table.unpack(t))
		end
	end
end
function s.effop(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(0,id,0,0,0)
	if not Duel.SelectYesNo(tp,aux.Stringid(id,0)) then return end
	local codet={}
	if Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
		local ac1=Duel.AnnounceCard(tp,0x6531,OPCODE_ISSETCARD)
		table.insert(codet,ac1)
	end
	if Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
		local ac2=Duel.AnnounceCard(tp,0x6532,OPCODE_ISSETCARD)
		table.insert(codet,ac2)
	end
	if Duel.SelectYesNo(tp,aux.Stringid(id,3)) then
		local ac3=Duel.AnnounceCard(tp,0x9532,OPCODE_ISSETCARD)
		table.insert(codet,ac3)
	end
	if Duel.SelectYesNo(tp,aux.Stringid(id,4)) then
		local ac4=Duel.AnnounceCard(tp,0xa532,OPCODE_ISSETCARD)
		table.insert(codet,ac4)
	end
	if Duel.SelectYesNo(tp,aux.Stringid(id,5)) then
		local ac5=Duel.AnnounceCard(tp,0xc533,OPCODE_ISSETCARD)
		table.insert(codet,ac5)
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(s.rcon)
	e1:SetOperation(s.rop(codet))
	Duel.RegisterEffect(e1,tp)
end
function s.rcon(e,tp,eg,ep,ev,re,r,rp)
	if not re then return false end
	e:SetLabel(re:GetHandler():GetCode())
	return true
end
function s.rop(codet)
	return  function(e,tp,eg,ep,ev,re,r,rp)
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
				e1:SetCode(EVENT_CHAIN_SOLVING)
				e1:SetLabel(Duel.GetCurrentChain(),e:GetLabel())
				e1:SetLabelObject(e)
				e1:SetOperation(s.ceop(codet))
				e1:SetReset(RESET_CHAIN)
				Duel.RegisterEffect(e1,tp)
			end
end
function s.ceop(codet)
	return  function(e,tp,eg,ep,ev,re,r,rp)
				local chainc,code=e:GetLabel()
				if Duel.GetCurrentChain()~=chainc then return end
				local rc=re:GetHandler()
				local res=false
				for k,v in pairs(codet) do
					if code==v then
						res=true
						table.remove(codet,k)
						break
					end
				end
				e:GetLabelObject():SetOperation(s.rop(codet))
				if not res then return end
				Duel.Hint(HINT_CARD,0,m)
				local setcard=0
				if rc:IsOriginalSetCard(0x6531) then setcard=0x6531 end
				if rc:IsOriginalSetCard(0x6532) then setcard=0x6532 end
				if rc:IsOriginalSetCard(0x9532) then setcard=0x9532 end
				if rc:IsOriginalSetCard(0xa532) then setcard=0xa532 end
				if rc:IsOriginalSetCard(0xc533) then setcard=0xc533 end
				if setcard==0 then return end
				local g=Group.CreateGroup()
				Duel.ChangeTargetCard(ev,g)
				Duel.ChangeChainOperation(ev,s.repop(setcard))
				e:Reset()
			end
end
function s.thfilter(c,tp,setcard)
	if not c:IsAbleToHand() then return false end
	if setcard==0x6531 and not c:IsCode(53757001) then return false end
	if setcard==0x6532 and not c:IsCode(53757003) then return false end
	if setcard==0x9532 and not c:IsCode(53757005) then return false end
	if setcard==0xa532 and not c:IsCode(53757007) then return false end
	if setcard==0xc533 and not c:IsCode(53757009) then return false end
	return Duel.IsExistingMatchingCard(s.thfilter2,tp,LOCATION_DECK,0,1,c,c:GetCode())
end
function s.thfilter2(c,code)
	return aux.IsCodeListed(c,code) and c:IsAbleToHand()
end
function s.repop(setcard)
	return  function(e,tp,eg,ep,ev,re,r,rp)
				local c=e:GetHandler()
				if Duel.Remove(c,POS_FACEUP,REASON_EFFECT)==0 or not c:IsLocation(LOCATION_REMOVED) then return end
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
				local tc=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil,tp,setcard):GetFirst()
				if not tc then return end
				local g=Duel.SelectMatchingCard(tp,s.thfilter2,tp,LOCATION_DECK,0,1,1,nil,tc:GetCode())
				g:AddCard(tc)
				Duel.SendtoHand(g,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,g)
			end
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,0xff,0xff)
	for tc in aux.Next(g) do if tc:IsOriginalSetCard(0x6531,0x6532,0x9532,0xa532,0xc533) then table.insert(DimenCard_Table,tc:GetOriginalCodeRule()) end end
	e:Reset()
end
