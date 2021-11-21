--沼地的魔精灵
function c4591277.initial_effect(c)
	c:SetSPSummonOnce(4591277)
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,4591277,aux.FilterBoolFunction(Card.IsRace,RACE_AQUA),1,true,true)
	--cos
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(4591277,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c4591277.coscost)
	e1:SetOperation(c4591277.cosoperation)
	c:RegisterEffect(e1)
	--grave fusion material
	if not aux.bog_grave_fus_mat then
		aux.bog_grave_fus_mat=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD)
		ge1:SetCode(EFFECT_EXTRA_FUSION_MATERIAL)
		ge1:SetTargetRange(LOCATION_GRAVE,0)
		ge1:SetTarget(c4591277.mttg)
		ge1:SetValue(c4591277.mtval)
		Duel.RegisterEffect(ge1,0)
		local ge2=ge1:Clone()
		Duel.RegisterEffect(ge2,1)
	end
	--workaround
	if not aux.fus_mat_hack_check then
		aux.fus_mat_hack_check=true
		function aux.fus_mat_hack_exmat_filter(c)
			return c:IsHasEffect(EFFECT_EXTRA_FUSION_MATERIAL,c:GetControler())
		end
		_SendtoGrave=Duel.SendtoGrave
		function Duel.SendtoGrave(tg,reason)
			if reason~=REASON_EFFECT+REASON_MATERIAL+REASON_FUSION or Auxiliary.GetValueType(tg)~="Group" then
				return _SendtoGrave(tg,reason)
			end
			local rg=tg:Filter(Card.IsLocation,nil,LOCATION_GRAVE)
			tg:Sub(rg)
			local tc=rg:Filter(aux.fus_mat_hack_exmat_filter,nil):GetFirst()
			if tc then
				local te=tc:IsHasEffect(EFFECT_EXTRA_FUSION_MATERIAL,tc:GetControler())
				te:UseCountLimit(tc:GetControler())
			end
			local ct1=_SendtoGrave(tg,reason)
			local ct2=Duel.Remove(rg,POS_FACEUP,reason)
			return ct1+ct2
		end
	end
end
function c4591277.mttg(e,c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToRemove()
end
function c4591277.mtval(e,c)
	if not c then return false end
	return c:IsCode(4591277)
end
function c4591277.filter2(c,fc)
	return c:GetCode()==fc:GetCode()
end
function c4591277.filter1(c,tp)
	return c:IsType(TYPE_FUSION) and Duel.IsExistingMatchingCard(c4591277.filter2,tp,LOCATION_EXTRA,0,2,c,c)
end
function c4591277.coscost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c4591277.filter1,tp,LOCATION_EXTRA,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,c4591277.filter1,tp,LOCATION_EXTRA,0,1,1,nil,tp)
	local cg=Duel.GetMatchingGroup(c4591277.filter2,tp,LOCATION_EXTRA,0,g:GetFirst(),g:GetFirst())
	g:Merge(cg)
	Duel.ConfirmCards(1-tp,g)
	e:SetLabel(cg:GetFirst():GetCode())
	e:SetLabelObject(g)
	g:KeepAlive()
end
function c4591277.cosoperation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=e:GetLabelObject()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	if g:Filter(Card.IsLocation,nil,LOCATION_EXTRA):GetCount()<3 then return false end
	Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CHANGE_CODE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	e1:SetValue(e:GetLabel())
	c:RegisterEffect(e1)
	local cid=c:CopyEffect(e:GetLabel(),RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(4591277,1))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCountLimit(1)
	e2:SetRange(LOCATION_MZONE)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	e2:SetLabelObject(e1)
	e2:SetLabel(cid)
	e2:SetOperation(c4591277.rstop)
	c:RegisterEffect(e2)
end
function c4591277.rstop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetTurnPlayer()==tp then return false end
	local c=e:GetHandler()
	local cid=e:GetLabel()
	if cid~=0 then
		c:ResetEffect(cid,RESET_COPY)
		c:ResetEffect(RESET_DISABLE,RESET_EVENT)
	end
	local e1=e:GetLabelObject()
	e1:Reset()
	Duel.HintSelection(Group.FromCards(c))
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
