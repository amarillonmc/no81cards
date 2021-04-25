--不可视之力
local m=33701424
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTarget(cm.damtg)
	e1:SetOperation(cm.damop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTarget(cm.damtg1)
	e2:SetOperation(cm.damop1)
	c:RegisterEffect(e2)
	
end
function cm.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,tp,1000)
end
function cm.damop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
	if c:IsRelateToEffect(e) and e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		c:CancelToGrave()
		Duel.SendtoDeck(c,nil,2,REASON_EFFECT)
	end
end
function cm.damtg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,tp,2000)
end
function cm.damop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if Duel.Damage(p,d,REASON_EFFECT)>0 then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
		local tc=g:GetFirst()
		if tc then
			local toGrave=false
			local flag=0
			local seq=tc:GetSequence()
			local p=tc:GetControler()
			if tc:IsLocation(LOCATION_FZONE) then toGrave=true
			elseif tc:IsLocation(LOCATION_MZONE) then
				if seq<=4 then
					if seq>0 and Duel.CheckLocation(tp,LOCATION_MZONE,seq-1) then flag=flag|(aux.SequenceToGlobal(p,LOCATION_MZONE,seq-1)) end
					if seq<4 and Duel.CheckLocation(tp,LOCATION_MZONE,seq+1) then flag=flag|(aux.SequenceToGlobal(p,LOCATION_MZONE,seq+1)) end
					if bit.band(tc:GetType(),TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_LINK+TYPE_PENDULUM)>0 and tc:IsFaceup() then
						if seq==1 then flag=flag|(aux.SequenceToGlobal(p,LOCATION_MZONE,5)) end
						if seq==3 then flag=flag|(aux.SequenceToGlobal(p,LOCATION_MZONE,6)) end
					end
				else
					if seq==5 then flag=flag|(aux.SequenceToGlobal(p,LOCATION_MZONE,1))
					if seq==6 then flag=flag|(aux.SequenceToGlobal(p,LOCATION_MZONE,3))
				else toGrave=true
				end
			elseif tc:IsLocation(LOCATION_SZONE) then
				if seq<=4 then
					if seq>0 and Duel.CheckLocation(p,LOCATION_SZONE,seq-1) then flag=flag|(aux.SequenceToGlobal(p,LOCATION_SZONE,seq-1)) end
					if seq<4 and Duel.CheckLocation(p,LOCATION_SZONE,seq+1) then flag=flag|(aux.SequenceToGlobal(p,LOCATION_SZONE,seq+1)) end
				else toGrave=true
				end
			else toGrave=true
			end
			if not toGrave then
				Duel.Hint(HINT_SELECTMSG,p,HINTMSG_TOZONE)
				local s=Duel.SelectDisableField(p,1,LOCATION_ONFIELD,0,~flag)
				local nseq=math.log(s,2)
				nseq=nesq-p*16
				if tc:IsLocation(LOCATION_SZONE) then nseq=nseq-8
				Duel.MoveSequence(c,nseq)
			else
				if Duel.SendtoGrave(tc,REASON_EFFECT)~=0 then
					Duel.Draw(p,1,REASON_EFFECT)
				end
			end
		end
	end
end
