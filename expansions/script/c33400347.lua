--魔王剑-淫欲
local m=33400347
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1,m)
	e1:SetOperation(cm.cpop)
	c:RegisterEffect(e1)
--
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(m,1))
	e5:SetCategory(CATEGORY_TOGRAVE+CATEGORY_TOHAND+CATEGORY_REMOVE)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCountLimit(1,m+10000)
	e5:SetCost(cm.cost2)
	e5:SetTarget(cm.cptg)
	e5:SetOperation(cm.tgop2)
	c:RegisterEffect(e5)
 --back
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e9:SetCode(EVENT_ADJUST)
	e9:SetRange(LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_HAND+LOCATION_EXTRA)
	e9:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SET_AVAILABLE)
	e9:SetCondition(cm.backon)
	e9:SetOperation(cm.backop)
	c:RegisterEffect(e9)
end
function cm.cfilter(c)
	return c:IsSetCard(0x3342) and c:IsAbleToGraveAsCost()
end
function cm.cpop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	getmetatable(e:GetHandler()).announce_filter={0x5341,OPCODE_ISSETCARD,TYPE_SPELL+TYPE_TRAP,OPCODE_ISTYPE,OPCODE_NOT,OPCODE_AND}
	local ac=Duel.AnnounceCard(tp,table.unpack(getmetatable(e:GetHandler()).announce_filter))
	--effect gain
	local key=1
	local tg=Duel.GetMatchingGroup(Card.IsOriginalCodeRule,tp,LOCATION_ONFIELD+LOCATION_EXTRA+LOCATION_GRAVE+LOCATION_REMOVED,0,nil,33400329)
	local tc=tg:GetFirst()
	while tc do
		if tc:GetFlagEffect(ac)==0 then
		tc:RegisterFlagEffect(ac,0,EFFECT_FLAG_CLIENT_HINT,0,0,aux.Stringid(ac,5))
		else key=0 
		end
		tc=tg:GetNext()
	end
	if key==0 then return end
	local cp={}
	local func=Card.RegisterEffect
	Card.RegisterEffect=function(tc,e,f)
		local pro=e:GetProperty()
		if e:GetRange()&LOCATION_MZONE~=0 and pro&EFFECT_FLAG_UNCOPYABLE==0 then
			table.insert(cp,e:Clone())
		end
		return func(tc,e,f)
	end
	Duel.CreateToken(tp,ac)
	for i,v in ipairs(cp) do
		v:SetCost(aux.TRUE)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
		e1:SetTargetRange(LOCATION_MZONE,0)
		e1:SetLabel(ac)
		e1:SetTarget(cm.eftg)
		e1:SetLabelObject(v)
		Duel.RegisterEffect(e1,tp)
	end
	Card.RegisterEffect=func
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetLabel(ac)
	e2:SetTarget(cm.eftg)
	e2:SetLabelObject(v)
	Duel.RegisterEffect(e2,tp)
   
end
function cm.eftg(e,c)
	return c:IsOriginalCodeRule(33400329)
end

function cm.refilter(c,tp,re)
	local flag=true
	local value={Duel.IsPlayerAffectedByEffect(tp,EFFECT_CANNOT_RELEASE)}
	if #value>0 then
		for k,re in ipairs(value) do
			local val=re:GetTarget()
			if val and val(re,c,tp) then
				flag=false
			end
		end 
	end
	return  c:IsReleasable() or (c:IsType(TYPE_SPELL+TYPE_TRAP)  and flag)
end
function cm.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.refilter,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectMatchingCard(tp,cm.refilter,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,1,nil,tp)
	if g:GetCount()>0  then  
		local ck=0 
		local tc=g:GetFirst()
		Duel.Release(tc,REASON_COST)
	end
end
function cm.cfilter(c)
	return c:IsSetCard(0x3342) and c:IsAbleToGraveAsCost()
end
function cm.thfilter2(c,tp)
	return c:IsCode(33400751) 
		and (c:IsAbleToHand() or c:GetActivateEffect():IsActivatable(tp))
end
function cm.cpfilter(c)
	return  c:IsType(TYPE_SPELL+TYPE_TRAP)  and c:CheckActivateEffect(false,true,false)~=nil
end
function cm.cptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.cpfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_GRAVE+LOCATION_REMOVED,1,nil) end
end
function cm.tgop2(e,tp,eg,ep,ev,re,r,rp)
	local key=1
		local g=Duel.GetMatchingGroup(cm.cfilter,tp,0,LOCATION_HAND+LOCATION_MZONE,nil)
		if g:GetCount()>0 and Duel.SelectYesNo(1-tp,aux.Stringid(m,2)) then
			Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_TOGRAVE)
			local sg=g:Select(1-tp,1,1,nil)
			Duel.SendtoGrave(sg,REASON_EFFECT)  
			key=0
			 if Duel.IsExistingMatchingCard(cm.thfilter2,tp,0,LOCATION_GRAVE+LOCATION_DECK+LOCATION_REMOVED,1,nil,1-tp) and Duel.SelectYesNo(1-tp,aux.Stringid(m,3)) then
				Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_OPERATECARD)
				local g3=Duel.SelectMatchingCard(1-tp,cm.thfilter2,1-tp,LOCATION_GRAVE+LOCATION_DECK+LOCATION_REMOVED,0,1,1,nil,1-tp)
				local tc=g3:GetFirst()
				if tc then
					local b1=tc:IsAbleToHand()
					local b2=tc:GetActivateEffect():IsActivatable(1-tp)
					if b1 and (not b2 or Duel.SelectOption(1-tp,1190,1150)==0) then
						Duel.SendtoHand(tc,nil,REASON_EFFECT)
						Duel.ConfirmCards(tp,tc)
					else
						Duel.MoveToField(tc,1-tp,1-tp,LOCATION_SZONE,POS_FACEUP,true)
						local te=tc:GetActivateEffect()
						local tep=tc:GetControler()
						local cost=te:GetCost()
						if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
					end
					Duel.SendtoGrave(e:GetHandler(),REASON_EFFECT)
				end   
			end
		end
	if key==1 and   Duel.IsExistingMatchingCard(cm.cpfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_GRAVE+LOCATION_REMOVED,1,nil)  then 
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,4))
	local cg=Duel.SelectMatchingCard(tp,cm.cpfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_GRAVE+LOCATION_REMOVED,1,1,nil)
	local te,ceg,cep,cev,cre,cr,crp=cg:GetFirst():CheckActivateEffect(false,true,true)
	local op=te:GetOperation()
	if op then op(e,tp,eg,ep,ev,re,r,rp) end
	end
end 

function cm.backon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return m-10 and c:GetOriginalCode()==m
end
function cm.backop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	c:SetEntityCode(m-10)
	Duel.ConfirmCards(tp,Group.FromCards(c))
	Duel.ConfirmCards(1-tp,Group.FromCards(c))
	c:ReplaceEffect(m-10,0,0)
end




