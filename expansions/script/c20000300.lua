--应敌模块-Summon
local m=20000300
local cm=_G["c"..m]
fu=fu or {}

function fu.copy(c,code)
	local tc=c
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_BE_MATERIAL)
	e0:SetProperty(EFFECT_FLAG_EVENT_PLAYER)
	e0:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
		return r==REASON_XYZ
	end)
	e0:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		e:SetProperty(EFFECT_FLAG_EVENT_PLAYER+EFFECT_FLAG_IGNORE_IMMUNE)
		local rc=e:GetHandler():GetReasonCard()
		local code=e:GetLabel()
		local cid=rc:CopyEffect(code,RESET_EVENT+RESETS_STANDARD,1)
		local e1=Effect.CreateEffect(e:GetHandler() )
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetCode(EFFECT_ADD_CODE)
		e1:SetValue(code)
		rc:RegisterEffect(e1,true)
		rc:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(code,1))
		if not rc:IsType(TYPE_EFFECT) then
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_ADD_TYPE)
			e2:SetValue(TYPE_EFFECT)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			rc:RegisterEffect(e2,true)
		end
		e:SetProperty(EFFECT_FLAG_EVENT_PLAYER)
	end)
	e0:SetLabel(code)
	tc:RegisterEffect(e0)
	return e0
end
function fu.give(c,code,cod,con,egf,cod1,cod2)
	local tc=c
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(code,0))
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetRange(LOCATION_HAND)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(cod)
	e1:SetCountLimit(1,code)
	e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
		return con(e,tp,eg,ep,ev,re,r,rp)
	end)
	e1:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk)
		local g=eg:Filter(egf,nil,tp)
		if chk==0 then return g:GetCount()>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false)and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
		Duel.SetTargetCard(eg)
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	end)
	e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		local g=eg:Filter(egf,nil,tp):Filter(Card.IsRelateToEffect,nil,e)
		local tc=g:GetFirst()
		while tc do 
			if tc:IsLocation(LOCATION_ONFIELD) then 
				tc:RegisterFlagEffect(code,RESET_PHASE+PHASE_END,0,1)
			end
			tc=g:GetNext()
		end
		if g:GetCount()>0 and Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT+REASON_TEMPORARY)~=0 then
			local tc=g:GetFirst()
			while tc do
				if tc:GetFlagEffect(code)~=0 then 
					tc:RegisterFlagEffect(code+1,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
				else
					tc:RegisterFlagEffect(code+2,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
				end
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
				e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
				e1:SetCode(EVENT_PHASE+PHASE_END)
				e1:SetReset(RESET_PHASE+PHASE_END)
				e1:SetCountLimit(1)
				e1:SetLabelObject(tc)
				e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
					return e:GetLabelObject():GetFlagEffect(code+1)~=0 or e:GetLabelObject():GetFlagEffect(code+2)~=0
				end)
				e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
					if e:GetLabelObject():GetFlagEffect(code+1)~=0 then
						Duel.ReturnToField(e:GetLabelObject())
					elseif e:GetLabelObject():GetFlagEffect(code+2)~=0 then
						Duel.SendtoHand(e:GetLabelObject(),e:GetLabelObject():GetPreviousControler(),REASON_EFFECT)
					end
				end)
				Duel.RegisterEffect(e1,tp)
				tc=g:GetNext()
			end
			if e:GetHandler():IsRelateToEffect(e)and e:GetHandler():IsLocation(LOCATION_HAND)and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
				Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)
			end
		end
	end)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_HAND,0)
	e2:SetTarget(function(e,c)
		return c:IsSetCard(0xfd3) and c:IsLocation(LOCATION_HAND) and c:IsType(TYPE_MONSTER)
	end)
	e2:SetLabelObject(e1)
	tc:RegisterEffect(e2)
	if cod1 then
		local e3=e1:Clone()
		e3:SetCode(cod1)
		local e4=e2:Clone()
		e4:SetLabelObject(e3)
		tc:RegisterEffect(e4)
	end
	if cod2 then
		local e3=e1:Clone()
		e3:SetCode(cod2)
		local e4=e2:Clone()
		e4:SetLabelObject(e3)
		tc:RegisterEffect(e4)
	end
	return e2
end
--[[
function fu.sup(c,code,agive,mgive)
	local tc=c
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(code,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
		return Duel.GetTurnPlayer()==tp
	end)
	e1:SetCost(function(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return not e:GetHandler():IsPublic() end
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_PUBLIC)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
		e:GetHandler():RegisterEffect(e1)
		e:GetHandler():RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END+RESET_OPPO_TURN,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(code,2))
	end)
	e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		agive(e,tp,eg,ep,ev,re,r,rp)
	end)
	tc:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_BE_MATERIAL)
	e2:SetProperty(EFFECT_FLAG_EVENT_PLAYER)
	e2:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
		return r==REASON_XYZ 
	end)
	e2:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		local c=e:GetHandler()
		local rc=c:GetReasonCard()
		mgive(rc)
		local e2=Effect.CreateEffect(rc)
		e2:SetType(EFFECT_TYPE_QUICK_O)
		e2:SetDescription(aux.Stringid(code,0))
		e2:SetRange(LOCATION_MZONE)
		e2:SetCode(EVENT_FREE_CHAIN)
		e2:SetCountLimit(1)
		e2:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
			agive((e,tp,eg,ep,ev,re,r,rp)
		end)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		rc:RegisterEffect(e2,true) 
		if not rc:IsType(TYPE_EFFECT) then
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_ADD_TYPE)
			e2:SetValue(TYPE_EFFECT)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			rc:RegisterEffect(e2,true)
		end
	end)
	tc:RegisterEffect(e2)
	return e1
end
--]]
-------------------------------
if not cm then return end
function cm.initial_effect(c)
	local e0=fu.copy(c,m)
	local e1=fu.give(c,m,EVENT_SUMMON_SUCCESS,function(e,tp,eg,ep,ev,re,r,rp)return true end,
	function(c,tp)return c:GetSummonPlayer()==1-tp and c:IsAbleToRemove()and c:IsLocation(LOCATION_MZONE)end,EVENT_SPSUMMON_SUCCESS,EVENT_FLIP_SUMMON_SUCCESS)
end