--魔导礼记 逸
local s,id,o=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	
	--recycle
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,3))
	e3:SetCategory(CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,id+10000)
	e3:SetCondition(s.rccon)
	e3:SetTarget(s.rctg)
	e3:SetOperation(s.rcop)
	c:RegisterEffect(e3)
end

function s.tgfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToGrave()
end
function s.rccon(e,tp,eg,ep,ev,re,r,rp)
	--Debug.Message(Duel.GetLocationCount(tp,LOCATION_SZONE))
	return Duel.GetLocationCount(tp,LOCATION_SZONE)==0
end

function s.rctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetHandler():IsAbleToHand() then
			return Duel.IsExistingMatchingCard(s.tgfilter,tp,LOCATION_ONFIELD,0,1,nil) 
		end
		return e:GetHandler():IsSSetable(true) and Duel.IsExistingMatchingCard(s.tgfilter,tp,LOCATION_SZONE,0,1,nil) 
	end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_ONFIELD)
end

function s.rcop(e,tp,eg,ep,ev,re,r,rp)
	local tg = nil
	local c=e:GetHandler()
	if c:IsAbleToHand() 
		and Duel.IsExistingMatchingCard(s.tgfilter,tp,LOCATION_ONFIELD,0,1,nil) 
	then
		tg = Duel.SelectMatchingCard(tp,s.tgfilter,tp,LOCATION_ONFIELD,0,1,99,nil)
	elseif c:IsSSetable(true) and Duel.IsExistingMatchingCard(s.tgfilter,tp,LOCATION_SZONE,0,1,nil) 
	then
		tg = Duel.SelectMatchingCard(tp,s.tgfilter,tp,LOCATION_SZONE,0,1,1,nil)
		if Duel.IsExistingMatchingCard(s.tgfilter,tp,LOCATION_ONFIELD,0,1,tg) then
			local tmp = Duel.SelectMatchingCard(tp,s.tgfilter,tp,LOCATION_ONFIELD,0,0,99,tg)
			if #tmp>0 then tg.Merge(tmp) end
		end
	end
	if #tg>0 and Duel.SendtoGrave(tg,REASON_EFFECT)>0 and c:IsRelateToEffect(e) and c:IsLocation(LOCATION_GRAVE) then 
		local hflg = c:IsAbleToHand()
		local sflg = c:IsSSetable()
		local op=aux.SelectFromOptions(tp,{sflg,aux.Stringid(id,4)},{hflg,aux.Stringid(id,5)})	
		if op == 1 then
			Duel.SSet(tp,c)
		elseif op == 2 then
			Duel.SendtoHand(c,nil,REASON_EFFECT)
		end
	end
end

function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>4 end
end

function s.filter(c,e,tp)
	return c:IsType(TYPE_QUICKPLAY) and c:IsAbleToGrave()
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)==0 then return end
	Duel.ConfirmDecktop(tp,5)
	local g=Duel.GetDecktopGroup(tp,5):Filter(s.filter,nil,e,tp)
	local tc = nil
	if g:GetCount()>0
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local sg=g:Select(tp,1,1,nil)
		if Duel.SendtoGrave(sg,REASON_EFFECT)>0 then
			tc = sg:GetFirst()
		end
	end
	Duel.ShuffleDeck(tp)
	if tc and tc:CheckActivateEffect(false,true,false)~=nil 
		and Duel.SelectYesNo(tp,aux.Stringid(id,2))  
	then
		Duel.BreakEffect()
		local te,ceg,cep,cev,cre,cr,crp=tc:CheckActivateEffect(true,true,true)
		e:SetProperty(te:GetProperty())
		local tg=te:GetTarget()
		if tg then tg(e,tp,ceg,cep,cev,cre,cr,crp,1) end
		Duel.ClearOperationInfo(0)
		local op=te:GetOperation()
		if op then op(e,tp,eg,ep,ev,re,r,rp) end		
	end
end