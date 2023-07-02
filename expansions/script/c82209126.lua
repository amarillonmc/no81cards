--先史遗产-隰有苌楚
local m=82209126
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate  
	local e1=Effect.CreateEffect(c)  
	e1:SetType(EFFECT_TYPE_ACTIVATE)  
	e1:SetCode(EVENT_FREE_CHAIN)  
	c:RegisterEffect(e1)  
	--tohand  
	local e2=Effect.CreateEffect(c)   
	e2:SetType(EFFECT_TYPE_IGNITION)  
	e2:SetRange(LOCATION_SZONE)  
	e2:SetCountLimit(1)  
	e2:SetCost(cm.thcost)
	e2:SetTarget(cm.thtg)  
	e2:SetOperation(cm.thop)  
	c:RegisterEffect(e2)  
end
function cm.filter(c)  
	return c:IsSetCard(0x70) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()  
end  
function cm.randomnums(tp)
	local nums={4,4,4,4}
	for i=1,4 do
		local num=0
		local failed=true
		while failed do
			local repeated=false
			local code1=Duel.GetMatchingGroup(aux.TRUE,tp,0xff,0xff,nil):RandomSelect(3,1):GetFirst():GetOriginalCode()
			local code2=Duel.GetMatchingGroup(aux.TRUE,tp,0xff,0xff,nil):RandomSelect(3,1):GetFirst():GetOriginalCode()
			local diff=math.abs(code1-code2)
			num=math.fmod(diff,4)
			for j=1,4 do
				if i~=j and num==nums[j] then repeated=true end
			end
			failed=repeated
		end
		nums[i]=num
	end
	return nums
end
function cm.thcost(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return true end
	e:SetLabel(0)
	local oldChinese={"隰有苌楚，","猗傩其枝。","夭之沃沃，","乐子之无知。"}
	local options={cm.randomnums(tp),cm.randomnums(tp),cm.randomnums(tp),cm.randomnums(tp)}
	for i=1,4 do
		local option=options[i]
		local sentences={}
		local answer=0
		--generate answer
		for j=1,4 do 
			if option[j]==i-1 then
				answer=j-1
			end
		end
		--generate sentences
		for k=1,4 do
			table.insert(sentences,aux.Stringid(m,option[k]))
		end
		local selectedOption=Duel.SelectOption(tp,table.unpack(sentences))
		if selectedOption==answer then
			Debug.Message(oldChinese[i])
		else
			return false
		end
	end
	e:SetLabel(100)
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end  
	if e:GetLabel()==100 then
		e:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH) 
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)  
	end
end  
function cm.thop(e,tp,eg,ep,ev,re,r,rp)  
	if not e:GetHandler():IsRelateToEffect(e) then return end  
	if e:GetLabel()~=100 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)  
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.filter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)  
	if g:GetCount()>0 then  
		Duel.SendtoHand(g,nil,REASON_EFFECT)  
		Duel.ConfirmCards(1-tp,g)  
	end  
end  