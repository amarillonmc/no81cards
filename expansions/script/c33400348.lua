--魔王剑-贪欲
local m=33400348
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
--ChainLimit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_SZONE)
	e3:SetOperation(cm.chainop)
	c:RegisterEffect(e3)
--
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(m,1))
	e5:SetCategory(CATEGORY_TOGRAVE+CATEGORY_TOHAND)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCountLimit(1,m+10000)
	e5:SetCost(cm.cost2)
	e5:SetTarget(cm.tg)
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
function cm.chainop(e,tp,eg,ep,ev,re,r,rp)
	if  ep==tp then
		Duel.SetChainLimit(cm.chainlm)
	end
end
function cm.chainlm(e,rp,tp)
	return tp==rp
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
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then
	return Duel.IsExistingMatchingCard(cm.chfilter,tp,LOCATION_MZONE,0,1,nil)  
	end
end
function cm.cfilter(c)
	return c:IsSetCard(0xa341) and c:IsAbleToGraveAsCost()
end
function cm.thfilter2(c,tp)
	return c:IsCode(33400850,33400851) 
		and (c:IsAbleToHand() or c:GetActivateEffect():IsActivatable(tp))
end
function cm.mvfilter1(c)
	return c:IsFaceup() 
end
function cm.mvfilter2(c,tp)
	return c:IsFaceup()  and c:GetSequence()<5
		and Duel.IsExistingMatchingCard(cm.mvfilter3,tp,LOCATION_MZONE,0,1,c)
end
function cm.mvfilter3(c)
	return c:IsFaceup()  and c:GetSequence()<5
end
function cm.desfilter(c,g)
	return g:IsContains(c)
end
function cm.chfilter(c)
	return c:IsSetCard(0x341) and c:IsFaceup()
end
function cm.tgop2(e,tp,eg,ep,ev,re,r,rp)
	local key=1
		local g=Duel.GetMatchingGroup(cm.cfilter,tp,0,LOCATION_HAND+LOCATION_MZONE,nil)
		if g:GetCount()>0 and Duel.SelectYesNo(1-tp,aux.Stringid(m,6)) then
			Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_TOGRAVE)
			local sg=g:Select(1-tp,1,1,nil)
			Duel.SendtoGrave(sg,REASON_EFFECT)  
			key=0
			 if Duel.IsExistingMatchingCard(cm.thfilter2,tp,0,LOCATION_GRAVE+LOCATION_DECK+LOCATION_REMOVED,1,nil,1-tp) and Duel.SelectYesNo(1-tp,aux.Stringid(m,7)) then
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
	if key==1 then 
		  if Duel.SelectYesNo(tp,aux.Stringid(m,1)) then 
		   local b1=Duel.IsExistingMatchingCard(cm.mvfilter1,tp,LOCATION_MZONE,0,1,nil)
				and Duel.GetLocationCount(tp,LOCATION_MZONE,PLAYER_NONE,0)>0
		   local b2=Duel.IsExistingMatchingCard(cm.mvfilter2,tp,LOCATION_MZONE,0,1,nil,tp)
		  if not (b1 or b2)  then return 
		  end 
		  if b1 and b2 then op=Duel.SelectOption(tp,aux.Stringid(m,2),aux.Stringid(m,3))
			elseif b1 then op=Duel.SelectOption(tp,aux.Stringid(m,2))
			else op=Duel.SelectOption(tp,aux.Stringid(m,3))+1 
		  end
		   if op==0 then
				if Duel.GetLocationCount(tp,LOCATION_MZONE,PLAYER_NONE,0)<=0 then return 
				end
				Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,4))
				local g=Duel.SelectMatchingCard(tp,cm.mvfilter1,tp,LOCATION_MZONE,0,1,1,nil)
				if g:GetCount()>0 then
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
					local s=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,0)
					local nseq=math.log(s,2)
					Duel.MoveSequence(g:GetFirst(),nseq)
				end
		   else
				Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,5))
				local g1=Duel.SelectMatchingCard(tp,cm.mvfilter2,tp,LOCATION_MZONE,0,1,1,nil,tp)
				local tc1=g1:GetFirst()
				if not tc1 then return 
				end
				Duel.HintSelection(g1)
				Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,5))
				local g2=Duel.SelectMatchingCard(tp,cm.mvfilter3,tp,LOCATION_MZONE,0,1,1,tc1)
				Duel.HintSelection(g2)
				local tc2=g2:GetFirst()
				Duel.SwapSequence(tc1,tc2)
		   end
		end
		 local cg=Duel.GetMatchingGroup(cm.chfilter,tp,LOCATION_MZONE,0,nil)
			if cg:GetCount()==0 then return end
			local fc=cg:GetFirst()
			local sg=Group.CreateGroup()
			while fc do
				local ng=fc:GetColumnGroup()
				sg:Merge(ng)
				fc=cg:GetNext()
			end
			local sg2=Duel.GetMatchingGroup(cm.desfilter,tp,0,LOCATION_ONFIELD,nil,sg)
			if sg2:GetCount()>0 then
				Duel.BreakEffect()
				Duel.SendtoGrave(sg2,REASON_EFFECT+REASON_RULE)
			end
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





