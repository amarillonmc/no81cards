--万物见证者
local s,id,o=GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,id)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)

	--change
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_LEAVE_FIELD_P)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetOperation(s.chop)
	c:RegisterEffect(e3)
	if not s.global_check then
		s.global_check=true
		s.codetable={}
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAINING)
		ge1:SetOperation(s.addcodeop)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_CHAIN_END)
		ge2:SetOperation(s.delcodeop)
		Duel.RegisterEffect(ge2,0)
		_IsSetCard=Card.IsSetCard
		Card.IsSetCard=function (c,...)
			if _IsSetCard(c,...) then return true end
			if #s.codetable>0 and c:IsCode(id) then
				for i,v in ipairs(s.codetable) do
					if _IsSetCard(v,...) then return true end
				end
			end
			return false
		end
		_IsLinkSetCard=Card.IsLinkSetCard
		Card.IsLinkSetCard=function (c,...)
			if _IsLinkSetCard(c,...) then return true end
			if #s.codetable>0 and c:IsCode(id) then
				for i,v in ipairs(s.codetable) do
					if _IsLinkSetCard(v,...) then return true end
				end
			end
			return false
		end
		_IsFusionSetCard=Card.IsFusionSetCard
		Card.IsFusionSetCard=function (c,...)
			if _IsFusionSetCard(c,...) then return true end
			if #s.codetable>0 and c:IsCode(id) then
				for i,v in ipairs(s.codetable) do
					if _IsFusionSetCard(v,...) then return true end
				end
			end
			return false
		end
		_IsPreviousSetCard=Card.IsPreviousSetCard
		Card.IsPreviousSetCard=function (c,...)
			if _IsPreviousSetCard(c,...) then return true end
			if #s.codetable>0 and c:IsCode(id) then
				for i,v in ipairs(s.codetable) do
					if _IsPreviousSetCard(v,...) then return true end
				end
			end
			return false
		end
		_IsOriginalSetCard=Card.IsOriginalSetCard
		Card.IsOriginalSetCard=function (c,...)
			if _IsOriginalSetCard(c,...) then return true end
			if #s.codetable>0 and c:IsCode(id) then
				for i,v in ipairs(s.codetable) do
					if _IsOriginalSetCard(v,...) then return true end
				end
			end
			return false
		end
	end
end
local KOISHI_CHECK=false
if Card.SetCardData then KOISHI_CHECK=true end
function s.addcodeop(e,tp,eg,ep,ev,re,r,rp)
	table.insert(s.codetable,re:GetHandler())
end
function s.delcodeop(e,tp,eg,ep,ev,re,r,rp)
	s.codetable={}
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local codenum=#s.codetable
	if codenum==0 then Debug.Message("素敵な劇に、素敵な観客") end
	if codenum==1 then Debug.Message("空席にはしないわ") end
	if codenum==2 then Debug.Message("見続ける。それが使命") end
	if codenum==3 then Debug.Message("喜び、悲しみ、全部！") end
	if codenum==4 then Debug.Message("視線を未来に預けるわ") end
	if codenum>=5 then Debug.Message("煌めく舞台を、ずっと！") end	
	if Duel.GetFlagEffect(tp,id)==0 then Duel.RegisterFlagEffect(tp,id,0,0,1) end
	if Duel.IsPlayerAffectedByEffect(tp,EFFECT_CHANGE_DAMAGE)==nil then
		--damage
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CHANGE_DAMAGE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetTargetRange(1,0)
		e1:SetLabel(tp)
		e1:SetReset(0)
		e1:SetValue(s.damval)
		Duel.RegisterEffect(e1,tp)
	end
	if codenum>=1 and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then Duel.Recover(tp,500,REASON_EFFECT) end
	if codenum>=2 and Duel.IsPlayerCanDraw(tp,1) and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then Duel.Draw(tp,1,REASON_EFFECT) end
	if codenum>=3 and Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(id,3)) then
		if KOISHI_CHECK then
			Duel.Hint(HINT_CARD,0,id+1)
			c:SetEntityCode(id+1)
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local dg=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
		if dg:GetCount()>0 then
			Duel.Destroy(dg,REASON_EFFECT)
		end
	end
end
function s.damval(e,re,val,r,rp)   
	local tp=e:GetLabel()
	if Duel.GetFlagEffect(tp,id)==0 then return val
	else 
		Duel.Hint(HINT_CARD,0,id)
		Duel.ResetFlagEffect(tp,id)
		return 0
	end
end
function s.chop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if KOISHI_CHECK then c:SetEntityCode(id) end
	Debug.Message("きっと続く!")
end