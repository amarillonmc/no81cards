--猫头鹰侦探二人组
if not pcall(function() require("expansions/script/c10199990") end) then require("script/c10199990") end
local m=33700936
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=rsef.SV_CHANGE(c,"code",33700069)
	e1:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	local f=function(e)
		local g=Duel.GetFieldGroup(e:GetHandlerPlayer(),LOCATION_GRAVE,0)
		return g:GetClassCount(Card.GetCode)>=15
	end
	local e2=rscf.SetSpecialSummonProduce(c,LOCATION_HAND,f)
	local f2=function(e)
		return Duel.GetCurrentPhase()==PHASE_MAIN1 and not Duel.CheckPhaseActivity()
	end
	local e3=rsef.I(c,{m,0},nil,"se,th,tg",nil,LOCATION_HAND,f2,nil,cm.tg,cm.op)
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<15 then return false end
		local g=Duel.GetDecktopGroup(tp,15)
		return g:FilterCount(Card.IsAbleToHand,nil)>0
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_DECK)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=aux.ExceptThisCard(e)
	local g=Duel.GetFieldGroup(tp,LOCATION_DECK,0)
	local t={}
	local f=math.floor(#g/15)
	local l=1
	while l<=f do
		t[l]=l*15
		l=l+1
	end
	local act=Duel.AnnounceNumber(tp,table.unpack(t))
	Duel.ConfirmDecktop(tp,act)
	local rg=Duel.GetDecktopGroup(tp,act)
	local codect=rg:GetClassCount(Card.GetCode)
	if codect<act then
		if c then Duel.SendtoGrave(c,REASON_EFFECT)
		Duel.ShuffleDeck(tp)
		return end
	end
	if rg:FilterCount(Card.IsAbleToHand,nil)<=0 or not Duel.SelectYesNo(tp,aux.Stringid(m,1)) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tg=rg:FilterSelect(tp,Card.IsAbleToHand,1,l-1,nil)
	if #tg>0 then 
		Duel.SendtoHand(tg,nil,2,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tg)
		Duel.ShuffleDeck(tp)
	end
end