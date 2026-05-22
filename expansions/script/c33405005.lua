--『星光歌剧』台本-骄傲Revue
local m=33405005
local cm=_G["c"..m]
function cm.initial_effect(c)
	  --Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
 --activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	--e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1,m)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
 --atk
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,m+10000)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(cm.atktg)
	e2:SetOperation(cm.atkop)
	c:RegisterEffect(e2)
end
function cm.filter(c)
	local tp=c:GetOwner()
	return c:IsSetCard(0x6410) and ((c:IsType(TYPE_CONTINUOUS) and not c:IsForbidden() and Duel.GetLocationCount(tp,LOCATION_SZONE)>0) 
	or ((c:IsType(TYPE_QUICKPLAY) or c:GetType()==TYPE_SPELL or c:GetType()==TYPE_TRAP) and c:CheckActivateEffect(false,false,false)~=nil ) 
	or (c:IsType(TYPE_FIELD) and not c:IsForbidden() and Duel.GetLocationCount(tp,LOCATION_FZONE)>0))
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
   if chkc then
		--local te=e:GetLabelObject()
		--local tg=te:GetTarget()
		return chkc:GetControler()==tp and chkc:GetLocation()==LOCATION_GRAVE and cm.filter(chkc)
	end
	if chk==0 then return Duel.IsExistingTarget(cm.filter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local tc=Duel.SelectTarget(tp,cm.filter,tp,LOCATION_GRAVE,0,1,1,nil):GetFirst()
	--local tc=g:GetFirst()
	--if not tc:IsType(TYPE_CONTINUOUS) and not tc:IsType(TYPE_FIELD) and tc:IsType(TYPE_QUICKPLAY) or tc:GetType()==TYPE_SPELL or tc:GetType()==TYPE_TRAP  then 
		--local te,ceg,cep,cev,cre,cr,crp=g:GetFirst():CheckActivateEffect(false,false,false)
		--Duel.ClearTargetCard()
		--g:GetFirst():CreateEffectRelation(e)
		--local tg=te:GetTarget()
		--if tg then tg(e,tp,ceg,cep,cev,cre,cr,crp,1) end
		--te:SetLabelObject(e:GetLabelObject())
		--e:SetLabelObject(te)
	--end
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	--local k=0
  --local tc
 	--if Duel.GetFirstTarget() then tc=Duel.GetFirstTarget() 
  	--k=1
 	--end 
	Duel.ConfirmCards(tp,tc)
	if ((tc:IsType(TYPE_CONTINUOUS) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0) or (tc:IsType(TYPE_FIELD) and Duel.GetLocationCount(tp,LOCATION_FZONE)>0)) 
		and not tc:IsForbidden() then 

 		if tc:IsType(TYPE_FIELD) then 
			Duel.MoveToField(tc,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
 		else
  	 	Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
 		end
	--end 
	elseif (tc:IsType(TYPE_QUICKPLAY) or tc:GetType()==TYPE_SPELL or c:GetType()==TYPE_TRAP) and tc:CheckActivateEffect(false,false,false)~=nil then
  --if k==0 then
   	--local te=e:GetLabelObject()
		--if not te then return end
		--if not te:GetHandler():IsRelateToEffect(e) then return end
		--e:SetLabelObject(te:GetLabelObject())
		--local op=te:GetOperation()
		--if op then op(e,tp,eg,ep,ev,re,r,rp) end
		cm.ActivateCard(tc,tp,e,eg,ep,ev,re,r,rp)
  end
end

function cm.atkfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x6410) and c:IsType(TYPE_MONSTER)
end
function cm.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.atkfilter,tp,LOCATION_MZONE,0,1,nil) end
end
function cm.atkop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.atkfilter,tp,LOCATION_MZONE,0,nil)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(1000)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		tc=g:GetNext()
	end
end

function cm.ActivateCard(c,tp,oe,eg,ep,ev,re,r,rp)
	local e=c:GetActivateEffect()
	local cos,tg,op=e:GetCost(),e:GetTarget(),e:GetOperation()
	if e and (not cos or cos(e,tp,eg,ep,ev,re,r,rp,0)) and (not tg or tg(e,tp,eg,ep,ev,re,r,rp,0)) then
		oe:SetProperty(e:GetProperty())
		local code=c:GetOriginalCode()
		Duel.Hint(HINT_CARD,tp,code)
		Duel.Hint(HINT_CARD,1-tp,code)
		e:UseCountLimit(tp,1,true)
		c:CreateEffectRelation(e)
		if cos then cos(e,p,eg,ep,ev,re,r,rp,1) end
		if tg then tg(e,tp,eg,ep,ev,re,r,rp,1) end
		local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
		if g and #g~=0 then
			local tg=g:GetFirst()
			while tg do
				tg:CreateEffectRelation(e)
				tg=g:GetNext()
			end
		end
		if op then op(e,tp,eg,ep,ev,re,r,rp) end
		c:ReleaseEffectRelation(e)
		if g then
			tg=g:GetFirst()
			while tg do
				tg:ReleaseEffectRelation(e)
				tg=g:GetNext()
			end
		end
	end
end