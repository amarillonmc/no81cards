--混调色-深黑
local s,id,o=GetID()
s.named_with_Combine_Color=1
function s.cc(c)
	if not c then return false end
	if _G["Combine_Color_Global_Codes"] and (_G["Combine_Color_Global_Codes"][c:GetCode()] or _G["Combine_Color_Global_Codes"][c:GetOriginalCode()]) then return true end
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Combine_Color
end
function s.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,s.ffilter,3,true)
	s.substitute_check(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(s.atkval)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,2))
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetCondition(s.cpcon)
	e3:SetValue(s.cpval)
	c:RegisterEffect(e3)
end
s.material_type=TYPE_SYNCHRO
function s.ffilter(c,fc,sub,mg,sg)
	return (s.cc(c) or c:IsType(TYPE_FUSION+TYPE_SYNCHRO)) and (not sg or not sg:IsExists(Card.IsFusionCode,1,c,c:GetFusionCode()))
end
function s.cpcon(e)
	return e:GetHandler():GetFlagEffect(id)>0
end
function s.cpval(e)
	local c=e:GetHandler()
	if c:GetFlagEffect(id+100)==0 then
		c:RegisterFlagEffect(id+100,RESET_EVENT+RESETS_STANDARD,0,1)
		local mg=c:GetMaterial():Filter(Card.IsType,nil,TYPE_MONSTER)
		for tc in aux.Next(mg) do
			c:CopyEffect(tc:GetOriginalCode(),RESET_EVENT+RESETS_STANDARD,1)
		end
	end
	return 0
end
s.substitute_data=nil
function s.substitute_check(c)
	if s.substitute_hooked then return end
	s.substitute_hooked=true
	local old_SetFusionMaterial=Duel.SetFusionMaterial
	local old_SendtoGrave=Duel.SendtoGrave
	local old_SelectFusionMaterial=Duel.SelectFusionMaterial
	s.target_fc=nil
	Duel.SelectFusionMaterial=function(tp,fc,...)
		if fc and fc:IsType(TYPE_FUSION) then
			s.target_fc=fc
		end
		return old_SelectFusionMaterial(tp,fc,...)
	end
	Duel.SetFusionMaterial=function(g)
		local tc=g:Filter(aux.FilterBoolFunction(Card.IsCode,id),nil):GetFirst()
		if tc and tc:IsFaceup() and tc:IsOnField() then
			s.substitute_data={card=tc,group=g:Clone()}
			local e_block=Effect.CreateEffect(tc)
			e_block:SetType(EFFECT_TYPE_FIELD)
			e_block:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
			e_block:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e_block:SetTargetRange(1,0)
			e_block:SetReset(RESET_CHAIN)
			e_block:SetTarget(function(_,sc) return sc:IsLocation(LOCATION_EXTRA) and sc:IsType(TYPE_FUSION) end)
			Duel.RegisterEffect(e_block,tc:GetControler())
			Duel.SendtoGrave=function(sg,reason)
				if reason&REASON_MATERIAL~=0 then
					Duel.SendtoGrave=old_SendtoGrave
					Duel.SendtoDeck(sg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT+REASON_MATERIAL)
					return sg:GetCount()
				end
				return old_SendtoGrave(sg,reason)
			end
			g:RemoveCard(tc)
			Duel.RaiseEvent(tc,EVENT_SPSUMMON_SUCCESS,nil,REASON_MATERIAL,c:GetControler(),c:GetControler(),0)
		end
		return old_SetFusionMaterial(g)
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAIN_END)
	e1:SetCondition(s.substitute_condition)
	e1:SetOperation(s.substitute_op)
	Duel.RegisterEffect(e1,0)
end
function s.substitute_condition(e,tp,eg,ep,ev,re,r,rp)
	return s.substitute_data~=nil
end
function s.substitute_op(e,tp,eg,ep,ev,re,r,rp)
	local data=s.substitute_data
	s.substitute_data=nil
	local c=data.card
	if not c:IsFaceup() or not c:IsOnField() then return end
	local fc=s.target_fc
	s.target_fc=nil
	local other=data.group:Clone()
	other:RemoveCard(c)
	if fc then Duel.ConfirmCards(1-tp,fc) end
	local new_mat=other:Clone()
	local old_mat=c:GetMaterial():Clone()
	if fc then new_mat:AddCard(fc) end
	new_mat:Merge(old_mat)
	c:SetMaterial(new_mat)
	c:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,0,1)
	c:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(id,1))
end
function s.atkval(e,c)
	local g=c:GetMaterial()
	if g:GetCount()==0 then return 0 end
	local mt={}
	for tc in aux.Next(g) do
		if tc:IsType(TYPE_MONSTER) then mt[TYPE_MONSTER]=true end
		if tc:IsType(TYPE_SPELL) then mt[TYPE_SPELL]=true end
		if tc:IsType(TYPE_TRAP) then mt[TYPE_TRAP]=true end
	end
	local ct=0
	if mt[TYPE_MONSTER] then ct=ct+1 end
	if mt[TYPE_SPELL] then ct=ct+1 end
	if mt[TYPE_TRAP] then ct=ct+1 end
	return g:GetCount()*ct*200
end